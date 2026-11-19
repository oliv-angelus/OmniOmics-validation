import csv,sys,glob,os,collections
A=sys.argv[1]
T=[("B.subtilis",["Bacillus"]),("E.faecalis",["Enterococcus"]),("E.coli",["Escherichia","Shigella"]),("L.fermentum",["Lactobacillus fermentum","Limosilactobacillus"]),
   ("L.monocyt",["Listeria"]),("P.aeruginosa",["Pseudomonas"]),("S.enterica",["Salmonella"]),("S.aureus",["Staphylococcus"]),
   ("B.adolesc",["Bifidobacterium adolescentis","Bifidobacterium_adolescentis"]),("G.vaginalis",["Gardnerella","Bifidobacterium vaginale","Bifidobacterium_vaginale"]),
   ("B.burgdorf",["Borrelia","Borreliella"]),("C.trachom",["Chlamydia"])]
def target(sp):
    s=sp.replace("_"," ")
    for t,keys in T:
        for k in keys:
            if s.startswith(k.replace("_"," ")): return t
    return "OFF-TARGET"
def load(f):
    r=list(csv.reader(open(f),delimiter="\t")); h=r[0]; ai=h.index("abundance"); si=h.index("species")
    c=collections.Counter(); off=collections.Counter()
    for x in r[1:]:
        if x[0] in ("unmapped","mapped_unclassified") or not x[ai]: continue
        a=float(x[ai]); t=target(x[si]); c[t]+=a*100
        if t=="OFF-TARGET": off[x[si][:40]]+=a*100
    return c,off
runs=collections.OrderedDict()
runs["ONT vendor"]=[load(A+f"/ont_vendor/rep{r}.tsv") for r in (1,2,3)]
for lab,pat in [("GTDB+chim",A+"/../runs/prism/out/results/04_DENOISE/emu_gtdb_round2/{s}/{s}_rel-abundance.tsv"),("PIPELINE new",A+"/../runs/prism/out/results/04_DENOISE/emu/{s}/{s}_rel-abundance.tsv"),("GTDB nochim",A+"/prism_nochim/{s}/{s}_rel-abundance.tsv"),
                ("SILVA+chim",A+"/prism_silva/chim_{s}/{s}_rel-abundance.tsv"),("SILVA nochim",A+"/prism_silva/nochim_{s}/{s}_rel-abundance.tsv"),
                ("EmuDB+chim",A+"/emu_default/chim_{s}/{s}_rel-abundance.tsv"),("EmuDB nochim",A+"/emu_default/nochim_{s}/{s}_rel-abundance.tsv")]:
    for s in ["MSPLUS_REP1","MSPLUS_REP2","MSPLUS_REP3"]:
        f=pat.format(s=s)
        if os.path.exists(f): runs.setdefault(lab,[]).append(load(f))
print("%-13s"%"target"+"".join("%14s"%l for l in runs))
for t in [x[0] for x in T]+["OFF-TARGET"]:
    print("%-13s"%t+"".join("%14s"%("%.2f"%(sum(c[t] for c,_ in v)/len(v))) for v in runs.values()))
for l,v in runs.items():
    off=collections.Counter()
    for _,o in v: off.update(o)
    print(l,"top off-target:",[(k,round(x/len(v),2)) for k,x in off.most_common(4)])

def bc(a,b):
    keys=[x[0] for x in T]+["OFF-TARGET"]
    return sum(abs(a[k]-b[k]) for k in keys)/sum(a[k]+b[k] for k in keys)
print("Bray-Curtis (target-aggregated) to ONT vendor, per replicate:")
for l,v in runs.items():
    if l=="ONT vendor": continue
    print("  %-13s"%l, [round(bc(v[i][0],runs["ONT vendor"][i][0]),4) for i in range(len(v))])
print("  between ONT vendor replicates:", [round(bc(runs["ONT vendor"][i][0],runs["ONT vendor"][j][0]),4) for i,j in ((0,1),(0,2),(1,2))])
