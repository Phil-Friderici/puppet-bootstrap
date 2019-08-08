plan bootstrap::ec2(
  TargetSpec $nodes,
  Optional[String] $host_name = 'auto',
) {

  $r = run_task(bootstrap::ec2_provision, $nodes, host_name => $host_name)

  $nodes.apply_prep

  apply($nodes) {
    if $host_name == 'auto' {
      class { 'bootstrap::ec2': }
      -> class { 'bootstrap': }
    }
    else {
      class { 'bootstrap::ec2': host_name => $host_name }
      -> class { 'bootstrap': }
    }
  }

  return $r

}
