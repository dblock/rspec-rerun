def system!(cmd)
  rc = system(cmd)
  fail "failed with exit code #{$?.exitstatus}" if rc.nil? || !rc || $?.exitstatus != 0
end
