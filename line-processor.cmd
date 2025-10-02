set "INFILE=META-INF\MANIFEST.MF"

del foo.txt

for /f "userbackq delims=" %%A in (%INFILE%) do (
    echo %%A >> foo.txt
)

