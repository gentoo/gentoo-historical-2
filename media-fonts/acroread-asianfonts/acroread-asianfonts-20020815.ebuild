# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/acroread-asianfonts/acroread-asianfonts-20020815.ebuild,v 1.6 2004/08/29 23:42:40 kugelfang Exp $

DESCRIPTION="Asian Font Packs for Acrobat Reader 5.0"
HOMEPAGE="http://www.adobe.com/prodindex/acrobat/readstep.html"
BASE_URI="ftp://ftp.adobe.com/pub/adobe/acrobatreader/unix/5.x/"

SRC_URI="${BASE_URI}/chsfont.tar.gz
	${BASE_URI}/chtfont.tar.gz
	${BASE_URI}/jpnfont.tar.gz
	${BASE_URI}/korfont.tar.gz"

SLOT="0"
LICENSE="Adobe"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	app-text/acroread"
S="${WORKDIR}"

INSTALLDIR="/opt/Acrobat5/Resource/Font"

src_install() {
	dodir ${INSTALLDIR}
	for tarfile in `ls *KIT/*.TAR` ; do
		tar -xvf ${tarfile} --no-same-owner -C ${D}/${INSTALLDIR} || die
	done
	chown -R --dereference root:root ${D}/${INSTALLDIR}
}
