# Author Matthew Turk <m-turk@nwu.edu>
#
# This eClass is designed to be easy to use and implement.  The vast majority of
# LaTeX packages will only need to define SRC_URI (and sometimes S) for a
# successful installation.  If fonts need to be installed, then the variable
# SUPPLIER must also be defined.
#
# However, those packages that contain subdirectories must process each
# subdirectory individually.  For example, a package that contains directories
# DIR1 and DIR2 must call latex-package_src_compile() and
# latex-package_src_install() in each directory, as shown here:
#
# src_compile() {
#    cd ${S}
#    cd DIR1
#    latex-package_src_compile
#    cd ..
#    cd DIR2
#    latex-package_src_compile
# }
#
# src_install() {
#    cd ${S}
#    cd DIR1
#    latex-package_src_install
#    cd ..
#    cd DIR2
#    latex-package_src_install
# }
#
# The eClass automatically takes care of rehashing TeX's cache (ls-lR) after
# installation and after removal, as well as creating final documentation from
# TeX files that come with the source.  Note that we break TeX layout standards 
# by placing documentation in /usr/share/doc/${PN}
#
# For examples of basic installations, check out app-text/latex-aastex and
# app-text/latex-leaflet.
#
# NOTE: The CTAN "directory grab" function creates files with different MD5
# signatures EVERY TIME.  For this reason, if you are grabbing from the CTAN,
# you must either grab each file individually, or find a place to mirror an
# archive of them.  (iBiblio)

inherit base
INHERITED="$INHERITED $ECLASS"

newdepend ">=app-text/tetex-1.0.7
	   >=sys-apps/texinfo-4.2-r5"
ECLASS=latex-package
HOMEPAGE="http://www.tug.org/"
SRC_URI="ftp://tug.ctan.org/macros/latex/"
S=${WORKDIR}/${P}
TEXMF="/usr/share/texmf"
SUPPLIER="misc" # This refers to the font supplier; it should be overridden

latex-package_src_doinstall() {
    debug-print function $FUNCNAME $*
    # This actually follows the directions for a "single-user" system
    # at http://www.ctan.org/installationadvice/ modified for gentoo.
    [ -z "$1" ] && latex-package_src_install all

    while [ "$1" ]; do
        case $1 in
            "sh")
                for i in `find . -maxdepth 1 -type f -name "*.${1}"`
                do
                    dobin $i
                done
                ;;
            "sty" | "cls" | "fd" | "clo" | "def")
                for i in `find . -maxdepth 1 -type f -name "*.${1}"`
                do
                    insinto ${TEXMF}/tex/latex/${PN}
                    doins $i
                done
                ;;
            "dvi" | "ps" | "pdf")
                for i in `find . -maxdepth 1 -type f -name "*.${1}"`
                do
                    dodoc $i
                done
                ;;
	    "tex" | "dtx")
	    	for i in `find . -maxdepth 1 -type f -name "*.${1}"`
		do
		    texi2dvi -q -c --language=latex $i
		done
	        ;;
            "tfm" | "vf" | "afm" | "pfb")
                for i in `find . -maxdepth 1 -type f -name "*.${1}"`
                do
                    insinto ${TEXMF}/fonts/${1}/${SUPPLIER}/${PN}
                    doins $i
                done
                ;;
            "ttf")
                for i in `find . -maxdepth 1 -type f -name "*.ttf"`
                do
                    insinto ${TEXMF}/fonts/truetype/${SUPPLIER}/${PN}
                    doins $i
                done
                ;;
            "styles")
                latex-package_src_doinstall sty cls fd clo def
                ;;
            "doc")
                latex-package_src_doinstall tex dtx dvi ps pdf
                ;;
            "fonts")
                latex-package_src_doinstall tfm vg afm pfb ttf
                ;;
            "bin")
                latex-package_src_doinstall sh
                ;;
            "all")
                latex-package_src_doinstall styles doc fonts bin
                ;;
        esac
    shift
    done
}

latex-package_src_compile() {
    debug-print function $FUNCNAME $*
    cd ${S}
    for i in `find \`pwd\` -maxdepth 1 -type f -name "*.ins"`
    do
        echo "Extracting from $i"
        latex --interaction=batchmode $i > /dev/null
    done
}

latex-package_src_install() {
    debug-print function $FUNCNAME $*
    cd ${S}
    latex-package_src_doinstall all
}

latex-package_pkg_postinst() {
    debug-print function $FUNCNAME $*
    latex-package_rehash
}

latex-package_pkg_postrm() {
    debug-print function $FUNCNAME $*
    latex-package_rehash
}

latex-package_rehash() {
    debug-print function $FUNCNAME $*
    texconfig rehash
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_postrm
