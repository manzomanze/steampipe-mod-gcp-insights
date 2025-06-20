dashboard "compute_network_dashboard" {

  title         = "GCP Compute Network Dashboard"
  documentation = file("./dashboards/compute/docs/compute_network_dashboard.md")

  tags = merge(local.compute_common_tags, {
    type = "Dashboard"
  })

  container {

    card {
      query = query.compute_network_count
      width = 3
    }

    card {
      query = query.compute_network_total_mtu
      width = 3
    }

    card {
      query = query.compute_network_default_count
      width = 3
    }

    card {
      query = query.compute_network_no_subnet_count
      width = 3
    }

  }

  container {

    title = "Assessments"

    chart {
      title = "Default Networks"
      type  = "donut"
      width = 4
      query = query.compute_network_default_status

      series "count" {
        point "non-default" {
          color = "ok"
        }
        point "default" {
          color = "alert"
        }
      }
    }

    chart {
      title = "Empty Networks (No Subnets)"
      type  = "donut"
      width = 4
      query = query.compute_network_subnet_status

      series "count" {
        point "non-empty" {
          color = "ok"
        }
        point "empty" {
          color = "alert"
        }
      }
    }

  }

  container {

    title = "Analysis"

    chart {
      title = "Networks by Project"
      query = query.compute_network_by_project
      type  = "column"
      width = 4
    }

    chart {
      title = "Networks by Routing Mode"
      query = query.compute_network_by_routing_mode
      type  = "column"
      width = 4
    }

    chart {
      title = "Networks by Creation Mode"
      query = query.compute_network_by_creation_mode
      type  = "column"
      width = 4
    }

  }

}

# Card Queries

query "compute_network_count" {
  sql = <<-EOQ
    select count(*) as "Networks" from gcp_all.gcp_compute_network;
  EOQ
}

query "compute_network_total_mtu" {
  sql = <<-EOQ
    select sum(mtu) as "Total MTU (Bytes)" from gcp_all.gcp_compute_network;
  EOQ
}

query "compute_network_default_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'Default Networks' as label,
      case count(*) when 0 then 'ok' else 'alert' end as type
    from
      gcp_all.gcp_compute_network
    where
      name = 'default';
  EOQ
}

query "compute_network_no_subnet_count" {
  sql = <<-EOQ
    select
       count(*) as value,
       'Networks Without Subnets' as label,
       case when count(*) = 0 then 'ok' else 'alert' end as type
      from
        gcp_all.gcp_compute_network as n
        left join gcp_all.gcp_compute_subnetwork as s on n.name = s.network_name
      where
        s.id is null;
  EOQ
}

# Assessment Queries

query "compute_network_default_status" {
  sql = <<-EOQ
    select
      case
        when name = 'default' then 'default'
        else 'non-default'
      end as default_status,
      count(*)
    from
      gcp_all.gcp_compute_network
    group by
      default_status;
  EOQ
}

query "compute_network_subnet_status" {
  sql = <<-EOQ
    select
      case when s.id is null then 'empty' else 'non-empty' end as status,
      count(distinct n.id)
    from
       gcp_all.gcp_compute_network n
      left join gcp_all.gcp_compute_subnetwork s on s.network_name = n.name
    group by
      status;
  EOQ
}

# Analysis Queries

query "compute_network_by_project" {
  sql = <<-EOQ
    select
      p.title as "Project",
      count(n.*) as "total"
    from
      gcp_all.gcp_compute_network as n,
      gcp_all.gcp_project as p
    where
      p.project_id = n.project
    group by
      p.title
    order by count(n.*) desc;
  EOQ
}

query "compute_network_by_routing_mode" {
  sql = <<-EOQ
    select
      routing_mode as "Routing Mode",
      count(*) as "networks"
    from
      gcp_all.gcp_compute_network
    group by
      routing_mode
    order by
      routing_mode;
  EOQ
}

query "compute_network_by_creation_mode" {
  sql = <<-EOQ
    select
      case when auto_create_subnetworks then 'auto' else 'custom' end as "Creation Mode",
      count(*) as "networks"
    from
      gcp_all.gcp_compute_network
    group by
      auto_create_subnetworks
    order by
      auto_create_subnetworks;
  EOQ
}
