import sys,gzip,re,collections
tab,gff,out=sys.argv[1:4]
genes=collections.defaultdict(list)
for l in gzip.open(gff,"rt"):
    if l.startswith("#"): continue
    f=l.rstrip("\n").split("\t")
    if len(f)<9 or f[2]!="gene": continue
    a=dict(x.split("=",1) for x in f[8].split(";") if "=" in x)
    name=a.get("gene") or a.get("Name")
    if name: genes[f[6]].append((int(f[3]),int(f[4]),name))
n=0;m=0
with open(out,"w") as o:
    o.write("locus_tag\tgene\n")
    for i,l in enumerate(open(tab)):
        if i==0: h=l.rstrip("\n").split("\t"); continue
        f=l.rstrip("\n").split("\t"); r=dict(zip(h,f)); n+=1
        s,e,st=int(r["Start"]),int(r["End"]),r["Strand"]
        best=None;bo=0
        for gs,ge,name in genes[st]:
            ov=min(e,ge)-max(s,gs)+1
            if ov<=0: continue
            frac=min(ov/(e-s+1),ov/(ge-gs+1))
            if frac>bo: bo=frac;best=name
        if best and bo>=0.9: o.write(f"{r['locus_tag']}\t{best}\n"); m+=1
print(f"mapped {m}/{n} loci to RefSeq gene names")
