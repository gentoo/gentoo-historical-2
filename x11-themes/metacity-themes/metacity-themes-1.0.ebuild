# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/metacity-themes/metacity-themes-1.0.ebuild,v 1.2 2003/01/26 23:39:17 nall Exp $

DESCRIPTION="Some nice themes for MetaCity"
S=${WORKDIR}
THEME_URI="http://ftp.gnome.org/pub/GNOME/teams/art.gnome.org/themes/metacity/"
SRC_URI="${THEME_URI}CityBox-0.10.tar.gz
	${THEME_URI}MCity-Adept.tar.gz
	${THEME_URI}MCity-AEonMarbles-1.1.tar.bz2
	${THEME_URI}MCity-Amadeus-1.0.tar.gz
	${THEME_URI}MCity-Amber.tar.gz
	${THEME_URI}MCity-BeautifulAndFree-0.1.tar.gz
	${THEME_URI}MCity-Bee.tar.gz
	${THEME_URI}MCity-Carved-1.0.tar.gz
	${THEME_URI}MCity-Cazador.tar.gz
	${THEME_URI}MCity-Derivative_1.0.tar.gz
	${THEME_URI}MCity-Drake.tar.gz
	${THEME_URI}MCity-icE.tar.gz
	${THEME_URI}MCity-Immortal.tar.gz
	${THEME_URI}MCity-Iris.tar.gz
	${THEME_URI}MCity-Keramik-SCO-Blue-0.1.tar.gz
	${THEME_URI}MCity-McBlue-1.0.tar.gz
	${THEME_URI}MCity-McEazel-Blue.tar.gz
	${THEME_URI}MCity-MetaMile-Marker-0.2.tar.gz
	${THEME_URI}MCity-Outline.tar.gz
	${THEME_URI}MCity-Posh.tar.gz 
	${THEME_URI}MCity-PrettyMeta-Thin-0.1.tar.gz
	${THEME_URI}MCity-Quiet-Purple.tar.gz
	${THEME_URI}MCity-TigertCrack-1.2.1.tar.gz
	${THEME_URI}MCity-Ugly-0.2.tar.bz2
	${THEME_URI}MCity-Urbicande-1.0.tar.bz2
	${THEME_URI}SmallPill-Citrus-0.2.tar.gz"


HOMEPAGE="http://art.gnome.org/theme_list.php?category=metacity"

RDEPEND="x11-wm/metacity"

SLOT="1"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_unpack() {
	return 0
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodir /usr/share/themes
	cd ${D}/usr/share/themes

	unpack ${A}
	
	find .  -exec touch "{}" \;
	
	for dir in *
	do
		# Fix directory names that contain spaces
		if echo "${dir}" | egrep -q "[[:space:]]"
		then
			new_dir=`echo "${dir}" | sed -e 's: :_:g'`
			mv "${dir}" $new_dir
			dir=$new_dir
		fi
		
		if [ ! -d ${dir}/metacity-1 ]
		then
			mkdir tmp
			mv ${dir}/* tmp
			mv tmp ${dir}/metacity-1
		fi
	done
	
	# This patch corrects some XML files that are considered incomplete by
	# Metacity
	patch -p1 <${FILESDIR}/${P}-gentoo.diff
	
	chmod -R ugo=rX *
}
