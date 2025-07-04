dashboard "compute_network_detail" {

  title         = "GCP Compute Network Detail"
  documentation = file("./dashboards/compute/docs/compute_network_detail.md")

  tags = merge(local.compute_common_tags, {
    type = "Detail"
  })

  input "network_id" {
    title = "Select a network:"
    query = query.compute_network_input
    width = 4
  }

  container {

    card {
      width = 2
      query = query.compute_network_mtu
      args  = [self.input.network_id.value]
    }

    card {
      width = 2
      query = query.compute_network_routing_mode
      args  = [self.input.network_id.value]
    }

    card {
      width = 2
      query = query.compute_network_subnet_count
      args  = [self.input.network_id.value]
    }

    card {
      width = 2
      query = query.compute_network_is_default
      args  = [self.input.network_id.value]
    }

    card {
      width = 2
      query = query.network_firewall_rules_count
      args  = [self.input.network_id.value]
    }

    card {
      width = 2
      query = query.auto_create_subnetwork
      args  = [self.input.network_id.value]
    }
  }

  with "compute_vpn_gateways_for_compute_network" {
    query = query.compute_vpn_gateways_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_backend_services_for_compute_network" {
    query = query.compute_backend_services_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_firewalls_for_compute_network" {
    query = query.compute_firewalls_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_forwarding_rules_for_compute_network" {
    query = query.compute_forwarding_rules_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_instances_for_compute_network" {
    query = query.compute_instances_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_routers_for_compute_network" {
    query = query.compute_routers_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "compute_subnetworks_for_compute_network" {
    query = query.compute_subnetworks_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "dns_policies_for_compute_network" {
    query = query.dns_policies_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "kubernetes_clusters_for_compute_network" {
    query = query.kubernetes_clusters_for_compute_network
    args  = [self.input.network_id.value]
  }

  with "sql_database_instances_for_compute_network" {
    query = query.sql_database_instances_for_compute_network
    args  = [self.input.network_id.value]
  }

  container {

    graph {
      title = "Relationships"
      type  = "graph"

      node {
        base = node.compute_backend_service
        args = {
          compute_backend_service_ids = with.compute_backend_services_for_compute_network.rows[*].service_id
        }
      }

      node {
        base = node.compute_firewall
        args = {
          compute_firewall_ids = with.compute_firewalls_for_compute_network.rows[*].firewall_id
        }
      }

      node {
        base = node.compute_forwarding_rule
        args = {
          compute_forwarding_rule_ids = with.compute_forwarding_rules_for_compute_network.rows[*].rule_id
        }
      }

      node {
        base = node.compute_instance
        args = {
          compute_instance_ids = with.compute_instances_for_compute_network.rows[*].instance_id
        }
      }

      node {
        base = node.compute_network
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      node {
        base = node.compute_network_peers
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      node {
        base = node.compute_router
        args = {
          compute_router_ids = with.compute_routers_for_compute_network.rows[*].router_id
        }
      }

      node {
        base = node.compute_subnetwork
        args = {
          compute_subnetwork_ids = with.compute_subnetworks_for_compute_network.rows[*].subnetwork_id
        }
      }

      node {
        base = node.compute_vpn_gateway
        args = {
          compute_vpn_gateway_ids = with.compute_vpn_gateways_for_compute_network.rows[*].gateway_id
        }
      }

      node {
        base = node.dns_policy
        args = {
          dns_policy_ids = with.dns_policies_for_compute_network.rows[*].policy_id
        }
      }

      node {
        base = node.kubernetes_cluster
        args = {
          kubernetes_cluster_ids = with.kubernetes_clusters_for_compute_network.rows[*].cluster_id
        }
      }

      node {
        base = node.sql_database_instance
        args = {
          database_instance_self_links = with.sql_database_instances_for_compute_network.rows[*].self_link
        }
      }

      edge {
        base = edge.compute_network_to_compute_backend_service
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_network_to_compute_firewall
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_network_to_compute_forwarding_rule
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_subnetwork_to_compute_instance
        args = {
          compute_subnetwork_ids = with.compute_subnetworks_for_compute_network.rows[*].subnetwork_id
        }
      }

      edge {
        base = edge.compute_network_to_compute_network_peers
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_network_to_compute_router
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_network_to_compute_subnetwork
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_network_to_dns_policy
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_subnetwork_to_kubernetes_cluster
        args = {
          compute_subnetwork_ids = with.compute_subnetworks_for_compute_network.rows[*].subnetwork_id
        }
      }

      edge {
        base = edge.compute_network_to_sql_database_instance
        args = {
          compute_network_ids = [self.input.network_id.value]
        }
      }

      edge {
        base = edge.compute_vpn_gateway_to_compute_network
        args = {
          compute_vpn_gateway_ids = with.compute_vpn_gateways_for_compute_network.rows[*].gateway_id
        }
      }
    }
  }

  container {

    container {

      table {
        title = "Overview"
        width = 4
        type  = "line"
        query = query.compute_network_overview
        args  = [self.input.network_id.value]
      }

      table {
        title = "Peering Details"
        width = 8
        query = query.compute_network_peering
        args  = [self.input.network_id.value]
      }

    }

    container {

      table {
        title = "Subnet Details"
        query = query.compute_network_subnet
        args  = [self.input.network_id.value]
      }

    }

  }
}

# Input queries

query "compute_network_input" {
  sql = <<-EOQ
    select
      name as label,
      id::text || '/' || project as value,
      json_build_object(
        'project', project,
        'id', id::text
      ) as tags
    from
      gcp_all.gcp_compute_network
    order by
      title;
  EOQ
}

# Card queries

query "compute_network_mtu" {
  sql = <<-EOQ
    select
      'MTU (Bytes)' as label,
      mtu as value
    from
      gcp_all.gcp_compute_network
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}

query "compute_network_subnet_count" {
  sql = <<-EOQ
    with compute_subnetwork as (
      select
        network_name,
        project
      from
        gcp_all.gcp_compute_subnetwork
    ), compute_network as (
      select
        name,
        project,
        id
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      'Subnets' as label,
      count(*) as value,
      case when count(*) > 0 then 'ok' else 'alert' end as type
    from
      compute_subnetwork s,
      compute_network n
    where
      s.network_name = n.name
      and s.project = n.project;
  EOQ
}

query "compute_network_is_default" {
  sql = <<-EOQ
    select
      'Default Network' as label,
      case when name <> 'default' then 'ok' else 'Default Network' end as value,
      case when name <> 'default' then 'ok' else 'alert' end as type
    from
      gcp_all.gcp_compute_network
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}

query "compute_network_routing_mode" {
  sql = <<-EOQ
    select
      'Routing Mode' as label,
      initcap(routing_mode) as value
    from
      gcp_all.gcp_compute_network
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}

query "network_firewall_rules_count" {
  sql = <<-EOQ
    with compute_firewall as (
      select
        network,
        project
      from
        gcp_all.gcp_compute_firewall
    ), compute_network as (
      select
        name,
        project,
        id
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      'Firewall Rules' as label,
      count(f.*) as value,
      case when count(f.*) > 0 then 'ok' else 'alert' end as type
    from
      compute_firewall f,
      compute_network n
    where
      split_part(f.network, 'networks/', 2) = n.name
      and f.project = n.project;
  EOQ
}

query "auto_create_subnetwork" {
  sql = <<-EOQ
    select
      'Auto Create Subnetwork' as label,
      case when auto_create_subnetworks then 'Enabled' else 'Disabled' end as value,
      case when auto_create_subnetworks and name = 'default' then 'ok' else 'alert' end as type
    from
      gcp_all.gcp_compute_network
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}
# With queries

query "compute_vpn_gateways_for_compute_network" {
  sql = <<-EOQ
    with compute_ha_vpn_gateway as (
      select
        id,
        network
      from
        gcp_all.gcp_compute_ha_vpn_gateway
    ), compute_network as (
      select
        self_link,
        id
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      g.id::text as gateway_id
    from
      compute_ha_vpn_gateway g,
      compute_network n
    where
      g.network = n.self_link;
  EOQ
}

query "compute_backend_services_for_compute_network" {
  sql = <<-EOQ
    with compute_backend_service as (
      select
        id,
        network
      from
        gcp_all.gcp_compute_backend_service
    ), compute_network as (
      select
        self_link,
        id
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      bs.id::text as service_id
    from
      compute_backend_service bs,
      compute_network n
    where
      bs.network = n.self_link;
  EOQ
}

query "compute_firewalls_for_compute_network" {
  sql = <<-EOQ
    with compute_firewall as (
      select
        id,
        network
      from
        gcp_all.gcp_compute_firewall
    ), compute_network as (
      select
        self_link,
        id
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      f.id::text as firewall_id
    from
      compute_firewall f,
      compute_network n
    where
      f.network = n.self_link;
  EOQ
}

query "compute_forwarding_rules_for_compute_network" {
  sql = <<-EOQ
    select
      fr.id::text as rule_id
    from
      gcp_all.gcp_compute_forwarding_rule fr,
      gcp_all.gcp_compute_network n
    where
      split_part(fr.network, 'networks/', 2) = n.name
      and fr.project = n.project
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2)
    union

    select
      fr.id::text as rule_id
    from
      gcp_all.gcp_compute_global_forwarding_rule fr,
      gcp_all.gcp_compute_network n
    where
      split_part(fr.network, 'networks/', 2) = n.name
      and fr.project = n.project
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}

query "compute_instances_for_compute_network" {
  sql = <<-EOQ
    select
      i.id::text || '/' || i.project as instance_id
    from
      gcp_all.gcp_compute_instance i,
      gcp_all.gcp_compute_network n,
      jsonb_array_elements(network_interfaces) as ni
    where
      n.self_link = ni ->> 'network'
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}

query "compute_routers_for_compute_network" {
  sql = <<-EOQ
    select
      r.id::text as router_id
    from
      gcp_all.gcp_compute_router r,
      gcp_all.gcp_compute_network n
    where
      r.network = n.self_link
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}

query "compute_subnetworks_for_compute_network" {
  sql = <<-EOQ
    with compute_subnetwork as (
      select
        id,
        network,
        project
      from
        gcp_all.gcp_compute_subnetwork
    ), compute_network as (
      select
        id,
        self_link
      from
        gcp_all.gcp_compute_network
      where
        id = (split_part($1, '/', 1))::bigint
        and project = split_part($1, '/', 2)
    )
    select
      s.id::text || '/' || s.project as subnetwork_id
    from
      compute_subnetwork s,
      compute_network n
    where
      s.network = n.self_link;
  EOQ
}

query "dns_policies_for_compute_network" {
  sql = <<-EOQ
    select
      p.id::text as policy_id
    from
      gcp_all.gcp_dns_policy p,
      jsonb_array_elements(p.networks) pn,
      gcp_all.gcp_compute_network n
    where
      pn ->> 'networkUrl' = n.self_link
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}

query "kubernetes_clusters_for_compute_network" {
  sql = <<-EOQ
    select
      c.id::text || '/' || c.project as cluster_id
    from
      gcp_all.gcp_kubernetes_cluster c,
      gcp_all.gcp_compute_network n
    where
      c.network = n.name
      and c.project = n.project
      and n.id = (split_part($1, '/', 1))::bigint;
  EOQ
}

query "sql_database_instances_for_compute_network" {
  sql = <<-EOQ
    select
      i.self_link as self_link
    from
      gcp_all.gcp_sql_database_instance i,
      gcp_all.gcp_compute_network n
    where
      n.self_link like '%' || (i.ip_configuration ->> 'privateNetwork') || '%'
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}

# Other queries
query "compute_network_overview" {
  sql = <<-EOQ
    select
      name as "Name",
      id::text as "ID",
      creation_timestamp as "Creation Time",
      mtu as "MTU",
      routing_mode as "Routing Mode",
      location as "Location",
      project as "Project"
    from
      gcp_all.gcp_compute_network
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}

query "compute_network_peering" {
  sql = <<-EOQ
    select
      p ->> 'name' as "Name",
      p ->> 'state' as "State",
      p ->> 'stateDetails' as "State Details",
      p ->> 'autoCreateRoutes' as "Auto Create Routes",
      p ->> 'exchangeSubnetRoutes' as "Exchange Subnet Routes",
      p ->> 'exportSubnetRoutesWithPublicIp' as "Export Subnet Routes With Public IP"
    from
      gcp_all.gcp_compute_network,
      jsonb_array_elements(peerings) as p
    where
      id = (split_part($1, '/', 1))::bigint
      and project = split_part($1, '/', 2);
  EOQ
}

query "compute_network_subnet" {
  sql = <<-EOQ
    select
      s.name as "Name",
      s.id::text as "ID",
      s.creation_timestamp as "Creation Time",
      s.enable_flow_logs as "Enable Flow Logs",
      s.log_config_enable as "Log Config Enabled",
      s.gateway_address as "Gateway Address",
      s.ip_cidr_range as "IPv4 CIDR Range",
      s.ipv6_cidr_range as "IPv6 CIDR Range",
      s.private_ip_google_access as "Private IPv4 Google Access",
      s.private_ipv6_google_access as "Private IPv6 Google Access"
    from
      gcp_all.gcp_compute_subnetwork s,
      gcp_all.gcp_compute_network n
    where
      s.network_name = n.name
      and s.project = n.project
      and n.id = (split_part($1, '/', 1))::bigint
      and n.project = split_part($1, '/', 2);
  EOQ
}
