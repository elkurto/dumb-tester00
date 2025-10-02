set "INFILE=META-INF\MANIFEST.MF"

del foo.txt

for /f "userbackq delims=" %%A in (%INFILE%) do (
    echo %%A >> foo.txt
)


REM - The above idiom does note process trailing newlines.
REM - strangely one can use the above idiom to remove trailing newlines
