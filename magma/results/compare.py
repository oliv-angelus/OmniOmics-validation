"""MAGMA read-based abundance (Bracken, genus-summed) vs alignment-based
reference (same clean Illumina pairs mapped to the 10 Zymo genomes)."""
import csv, sys
D = sys.argv[1]
G = {"Pseudomonas_aeruginosa": ["Pseudomonas"], "Escherichia_coli": ["Escherichia", "Shigella"],
     "Salmonella_enterica": ["Salmonella"], "Lactobacillus_fermentum": ["Limosilactobacillus", "Lactobacillus"],
     "Enterococcus_faecalis": ["Enterococcus"], "Staphylococcus_aureus": ["Staphylococcus"],
     "Listeria_monocytogenes": ["Listeria"], "Bacillus_subtilis": ["Bacillus"],
     "Saccharomyces_cerevisiae": ["Saccharomyces"], "Cryptococcus_neoformans": ["Cryptococcus"]}
THEO = {"ZYMO_EVEN": dict.fromkeys([k for k in G if k not in ("Saccharomyces_cerevisiae", "Cryptococcus_neoformans")], 12.0) | {"Saccharomyces_cerevisiae": 2.0, "Cryptococcus_neoformans": 2.0},
        "ZYMO_LOG": {"Listeria_monocytogenes": 89.1, "Pseudomonas_aeruginosa": 8.9, "Bacillus_subtilis": 0.89, "Saccharomyces_cerevisiae": 0.89,
                     "Escherichia_coli": 0.089, "Salmonella_enterica": 0.089, "Lactobacillus_fermentum": 0.0089, "Enterococcus_faecalis": 0.00089,
                     "Cryptococcus_neoformans": 0.00089, "Staphylococcus_aureus": 0.000089}}
for s in ["ZYMO_EVEN", "ZYMO_LOG"]:
    al = {r["species"]: int(r["pairs_mapq10"] or r["pairs"]) for r in csv.DictReader(open(f"{D}/{s}_zymo10_counts.tsv"), delimiter="\t")}
    tot, un = al.pop("TOTAL"), al.pop("UNMAPPED")  # reference = uniquely placed pairs (MAPQ>=10)
    mapped = sum(al.values())
    br = list(csv.DictReader(open(f"{D}/{s}_bracken.txt"), delimiter="\t"))
    btot = sum(int(r["new_est_reads"]) for r in br)
    gen = {}
    for r in br:
        g = r["name"].split()[0]
        gen[g] = gen.get(g, 0) + int(r["new_est_reads"])
    print(f"\n== {s}: pairs {tot}, aligned to the 10 genomes {mapped} ({100*mapped/tot:.2f}%), unmapped {un} ({100*un/tot:.2f}%)")
    print(f"{'species':26s} {'theor%':>9s} {'aligned%':>9s} {'bracken%':>9s} {'rel.dev':>8s} {'within10%':>9s}")
    ok = 0
    for sp in sorted(G, key=lambda k: -al.get(k, 0)):
        a = 100 * al.get(sp, 0) / mapped
        b = 100 * sum(gen.get(g, 0) for g in G[sp]) / btot
        dev = (b - a) / a if a else float("nan")
        w = abs(dev) <= 0.10
        ok += w
        print(f"{sp:26s} {THEO[s][sp]:9.5f} {a:9.5f} {b:9.5f} {dev:+8.3f} {'yes' if w else 'no':>9s}")
    print(f"within +/-10% of the alignment reference: {ok}/10")
    known = {g for v in G.values() for g in v}
    off = sorted(((100 * n / btot, g) for g, n in gen.items() if g not in known), reverse=True)
    print(f"off-community (genera outside the 10 species): total {sum(x for x, _ in off):.3f}%; "
          f">=0.01%: {sum(1 for x, _ in off if x >= 0.01)} genera; top: " + ", ".join(f"{g} {x:.3f}%" for x, g in off[:6]))
