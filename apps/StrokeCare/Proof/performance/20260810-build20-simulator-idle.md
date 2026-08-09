# Build 20 visionOS Simulator idle-performance receipt

Timestamp: 2026-08-10 05:21 SGT  
Revision: `6fdfcb4`  
App: Stroke Care `0.6 (20)`  
Simulator: visionOS 26.5, `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`

This receipt tests the existing phase-aware animation-timeline change. It is
Simulator process evidence, not Vision Pro hardware, wearer, thermal, battery,
or release-performance proof.

## Method

For each deterministic route, Stroke Care was foreground-launched with
`--terminate-running-process`, allowed to settle for eight seconds, then sampled
six times at one-second intervals with:

```text
ps -p <pid> -o pid=,%cpu=,rss=,time=
```

The conflicting `com.arnav.RBCJourneyVision` immersive app was terminated
before each launch. The routes and observed CPU values were:

- `--proof-spatial-intake`: 9.7, 4.3, 9.7, 6.9, 9.0, 8.9%; average 8.08%.
- `--proof-spatial-docked-case`: 0.4, 0.4, 0.3, 0.3, 0.3, 0.3%; average 0.33%.
- `--proof-clinician-pressure`: 28.4, 29.4, 26.5, 26.3, 29.3, 29.1%; average
  28.17%.

The active Pressure route produced different screenshots eight seconds apart
(SHA-256 `d38d4841…135f2` and `8e149a1b…1457b`), confirming that the active
lesson did not become a frozen idle state.

A separate five-second `sample` pass on the intake route found the main thread
waiting in `mach_msg` for 3,462 of 3,742 samples and no Stroke Care function in
the collapsed hot-stack list. The remaining intake process cost is therefore
not attributed to a demonstrated app-level busy loop by this evidence.

## Verdict

`IMPROVED`, but issue #30 is not fully closed. Its historical 67.3–78.4% idle
Simulator samples are no longer reproduced: the unfolded review is nearly
idle, the archive threshold is materially lower, and active lesson animation
remains distinguishable. The exact historical measurement command was not
recorded, so this is not a perfectly controlled before/after benchmark.

Physical XCAT profiling, frame pacing, thermal behavior, and the residual
8.08% archive-threshold cost remain unproven. The next safe gate is to repeat
the same three routes on an awake, unlocked XCAT with Instruments.
