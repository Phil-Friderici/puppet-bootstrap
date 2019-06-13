plan bootstrap::ec2(TargetSpec $nodes) {

  $r = run_task(bootstrap::ec2_provision, $nodes)

  $nodes.apply_prep

  apply($nodes) {
    class { 'bootstrap::ec2': }
    -> class { 'bootstrap': }
  }

  return $r

}
