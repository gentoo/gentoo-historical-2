# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/artwiz-fonts/artwiz-fonts-2.4.ebuild,v 1.11 2005/12/14 17:46:42 joshuabaergen Exp $

S=${WORKDIR}/xfonts-artwiz-2.3/upstream
DESCRIPTION="Artwiz Fonts"
SRC_URI="http://ftp.debian.org/debian/pool/main/x/xfonts-artwiz/xfonts-artwiz_${PV}.tar.gz"
HOMEPAGE="http://fluxbox.sourceforge.net/docs/artwiz-fonts.php"

SLOT=0
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND="virtual/x11
	x11-apps/ttmkfdir"

src_compile() {
	cd ${S}
	for font in *.bdf; do
		/usr/X11R6/bin/bdftopcf ${font} > `basename $font .bdf`.pcf
	done
	gzip *.pcf
}

src_install() {
	cd ${S}
	insopts -m0644
	insinto /usr/share/fonts/artwiz/
	doins *.pcf.gz

#	These don't get downloaded because there is no simple way to
#	fetch them.. ie if I included the README in SRC_URI above, it would
#	get saved as /usr/portage/distfiles/README which doesn't seem like
#	a really good idea.
	dodoc ../COPYING

	if [ -z "$(grep artwiz /etc/X11/fs/config)" ]
	then
		sed 's#^catalog.*$#&\n\t/usr/share/fonts/artwiz:unscaled,#g' \
			/etc/X11/fs/config > ${S}/config
		insinto /etc/X11/fs
		doins config
	fi

}

pkg_postinst() {
	einfo ">>> Making font dirs..."
	cd /usr/share/fonts/artwiz
	mkfontdir
}
