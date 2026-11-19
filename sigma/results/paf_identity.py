"""Per-read alignment identity from a minimap2 PAF (primary alignments only).

identity = (L - NM) / L, L = alignment block length (PAF column 11), as in
Nicholls et al. 2019 (doi:10.1093/gigascience/giz043). Prints n, mean,
median and the length-weighted identity.
Usage: python paf_identity.py <label> <file.paf>
"""
import sys
import statistics

label, path = sys.argv[1], sys.argv[2]
ids, tot_l, tot_nm = [], 0, 0
with open(path) as f:
    for line in f:
        p = line.rstrip("\n").split("\t")
        if "tp:A:P" not in p[12:]:
            continue
        L = int(p[10])
        nm = next((int(x[5:]) for x in p[12:] if x.startswith("NM:i:")), None)
        if nm is None or L == 0:
            continue
        ids.append((L - nm) / L)
        tot_l += L
        tot_nm += nm
print("\t".join(["label", "n_primary", "mean_identity", "median_identity", "weighted_identity"]))
print("\t".join([label, str(len(ids)), f"{statistics.mean(ids):.5f}",
                 f"{statistics.median(ids):.5f}", f"{(tot_l - tot_nm) / tot_l:.5f}"]))
