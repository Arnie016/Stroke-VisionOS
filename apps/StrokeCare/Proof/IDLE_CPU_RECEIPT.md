# Static-room Simulator CPU receipt

Recorded: 2026-08-10 00:13 SGT

This is a Simulator process sample, not a wearer, XCAT, thermal, battery, or
release-performance result.

## Fixed method

- Simulator: visionOS 26.5, `F8B7E8FD-DBF2-4270-A6FD-2BA02CD6F777`
- Bundle: `com.arnav.StrokeTime`
- Route: `--proof-spatial-intake`
- Settle: 8 seconds
- Sampling: five `ps -p <pid> -o %cpu=,rss=` reads, two seconds apart
- Competing `com.arnav` immersive process absent from the accepted after sample

## Before

Installed verified build preceding the phase-aware timeline gate:

| Sample | CPU | RSS KB |
| --- | ---: | ---: |
| 1 | 29.3% | 464672 |
| 2 | 26.4% | 464560 |
| 3 | 24.6% | 464560 |
| 4 | 27.7% | 464560 |
| 5 | 27.8% | 464384 |

Median CPU: **27.7%**.

## After

Build: `/tmp/strokecare-idle-phase-gate/Build/Products/Debug-xrsimulator/StrokeTime.app`

| Sample | CPU | RSS KB |
| --- | ---: | ---: |
| 1 | 4.5% | 468544 |
| 2 | 7.3% | 468432 |
| 3 | 6.5% | 468432 |
| 4 | 7.4% | 468432 |
| 5 | 8.4% | 468432 |

Median CPU: **7.3%**, a **73.6% reduction** from this fixed baseline. RSS did
not improve and is not claimed as improved.

## Change and proof boundary

The 60 Hz `TimelineView` is paused in case-library and case-review phases, and
the hidden anatomy scene is no longer mutated there. Case unfolding remains
state-driven; active anatomy explanation retains its display-rate motion.

The contract passed, the OS 26.5 visionOS Simulator build succeeded, and the
`--proof-case-unfold` route still reached its authored final state. This does
not prove physical-device frame time, thermal behavior, battery impact,
gaze/pinch reliability, comfort, or clinical validity.
