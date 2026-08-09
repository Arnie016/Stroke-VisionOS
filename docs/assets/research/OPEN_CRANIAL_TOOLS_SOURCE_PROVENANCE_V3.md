# Open-cranial tools v3 — source and provenance ledger

## Geometry and material ownership

All geometry, material values, lighting, presentation layouts, previews, USD
exports, and metadata in this module were procedurally authored for this project
in `source/build_open_cranial_tools_v3.py`.

- No third-party mesh, CAD model, product scan, texture, HDRI, logo, trademark,
  packaging, or instrument catalogue image is included.
- No ImageGen or other raster-generation output is used by this module.
- No online asset was downloaded or modified.
- The instrument silhouettes are generic abstractions and deliberately omit
  manufacturer-specific geometry, connector standards, catalogue numbers,
  calibration, clinically meaningful markings, and product dimensions.
- Project-owned output is intended to remain unbranded. This statement is not a
  freedom-to-operate or regulatory determination.

## Clinical-category cross-checks

The sources below were used only to cross-check that the broad visual categories
exist in open cranial care. They were **not** used as operative instructions,
product specifications, or geometry references.

1. [MedlinePlus: Brain surgery](https://medlineplus.gov/ency/article/003018.htm)
   provides a high-level public explanation that some brain operations involve
   scalp and cranial access. It does not establish the right approach for a
   patient and is not encoded as a sequence in these assets.
2. [FDA neurological-device classification results](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?deviceclass=&devicename=&implant_flag=&life_sustain_support_flag=&pagenum=10&panel=&productcode=&regulationnumber=&sortcolumn=productcode&start_search=851&submission_type_id=1&summary_malfunction_reporting=&thirdparty=)
   list generic categories including cranial drills/burrs/trephines and
   accessories, cranioplasty plate fasteners, and ventricular catheters.
3. [FDA Class I neurological-device results](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpcd/classification.cfm?deviceclass=1&devicename=&implant_flag=&life_sustain_support_flag=&pagenum=25&panel=&productcode=&regulationnumber=&sortcolumn=productcode&start_search=751&submission_type_id=4&summary_malfunction_reporting=&thirdparty=)
   list generic categories including microsurgical instruments, nonpowered
   neurosurgical instruments, neurosurgical suture needles, and cranial drill
   handpieces.
4. [FDA: Classify Your Medical Device](https://www.fda.gov/medical-devices/overview-device-regulation/classify-your-medical-device)
   explains that generic device types receive regulatory classifications. It is
   cited to reinforce that a visual category is not a substitute for an actual
   regulated product, its labeling, or institutional review.
5. [FDA 510(k) summary for an irrigating bipolar-forceps category](https://www.accessdata.fda.gov/cdrh_docs/pdf8/K080187.pdf)
   was used only to confirm that paired forceps and an irrigation pathway can
   coexist as a general device category. No named product geometry, dimensions,
   materials, performance, labeling, or instructions were copied.

## Interpretation limits

The source checks support only the presence and naming of broad categories. They
do not validate:

- the completeness of the instrument set for any operation;
- tool selection, compatibility, dimensions, sterility, settings, or performance;
- the appropriateness of craniotomy, decompression, evacuation, drainage, or any
  other intervention;
- sequence, target, trajectory, depth, force, drilling/cutting behavior, suction
  or irrigation parameters, electrosurgical energy, fixation, or closure method;
- patient-specific anatomy, pathology, risk, consent, outcome, or postoperative
  management.

## Reproduction and audit trail

Run the Blender generator:

```bash
/Applications/Blender.app/Contents/MacOS/Blender \
  --background \
  --python vision_pro_stroke_kit_v2/source/build_open_cranial_tools_v3.py
```

Then run the independent validator:

```bash
python3 vision_pro_stroke_kit_v2/source/validate_open_cranial_tools_v3.py
```

The validator independently recomputes every package byte count and SHA-256,
runs `/usr/bin/usdchecker --arkit --strict`, inspects the metre/Y-up declarations,
checks that each USDZ has exactly one embedded USD stage, and loads every package
through RealityKit with nonzero model/material counts and positive bounds.

The authoritative per-package hashes are in:

- `asset_manifest_open_cranial_tools_v3.json`
- `validation/open_cranial_tools_v3_validation.json`
- `validation/OPEN_CRANIAL_TOOLS_ASSET_VALIDATION_V3.md`
