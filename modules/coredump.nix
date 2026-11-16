# Core dumps -- capped, because an uncapped one fills the disk.
#
# THE SYMPTOM, reported 2026-11-16: free space dropping from ~50 GB to zero for
# a few minutes, several times a week, then returning to normal. Slowdowns while
# it lasted.
#
# THE CAUSE. Brave renderer processes crash with SIGILL fairly often -- the
# journal shows one almost every night between 23:00 and 03:00, each preceded by
# a burst of `NVRM: dmaAllocMapping_GM107: can't alloc VA space for mapping`
# (560 of those in five days). When a renderer dies, systemd-coredump dumps it.
#
# And a Chromium renderer is the worst possible thing to dump:
#
#     RSS   0.4 GB        VSZ   1452 GB
#
# 400 MB of resident memory, but a 1.4 TB virtual address space -- Chromium
# reserves enormous mappings by design. systemd-coredump walks it and compresses
# on the fly into /var/lib/systemd/coredump, which is on the root filesystem. It
# filled the remaining 50 GB before any default limit stopped it, truncated the
# core, compressed the fragment down to ~58 MB and released the rest. Hence the
# spike that repairs itself.
#
# Every Brave core kept on this machine is marked `truncated` -- that is the
# fingerprint of the disk filling up, not of a limit doing its job. The
# corresponding "No space left on device" errors are in the journal on 09, 13
# and 16 November.
#
# WHY CAP RATHER THAN DISABLE. A core dump is occasionally useful, and the fix
# here is not to blind the system but to bound it. 2 GB is far more than enough
# for anything worth reading, and three orders of magnitude below what an
# unbounded Chromium dump costs. MaxUse keeps the archive itself from growing
# without limit -- 553 MB of stale Brave cores had already accumulated.
#
# To turn them off entirely instead:  systemd.coredump.enable = false;

{ ... }:

{
  # `extraConfig` was removed in 26.05; the build fails loudly on it and points
  # at `settings.Coredump`, which is the structured form.
  systemd.coredump.settings.Coredump = {
    # Beyond this, the process is not dumped at all. This is the line that
    # stops a 1.4 TB address space from ever touching the disk.
    ProcessSizeMax = "2G";

    # Upper bound on a single stored (compressed) core.
    ExternalSizeMax = "2G";

    # Upper bound on /var/lib/systemd/coredump as a whole.
    MaxUse = "1G";

    # Cores older than two weeks are dropped. They are only useful while the
    # crash is still fresh enough to act on.
    MaxAge = "2week";
  };
}
