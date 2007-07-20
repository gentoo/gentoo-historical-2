# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gaul-devel/gaul-devel-0.1846.ebuild,v 1.4 2007/07/20 18:45:10 je_fro Exp $

DESCRIPTION="Genetic Algorithm Utility Library"
HOMEPAGE="http://GAUL.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaul/${P}-0.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS=""

IUSE="slang doc"

DEPEND="slang? ( >=sys-libs/slang-1.4.5-r2 )
	>=sys-apps/sed-4.0.7"

RDEPEND="slang? ( >=sys-libs/slang-1.4.5-r2 )"

# Will talk to Stewart about his version scheme...
S=${WORKDIR}/${P}-0

src_compile() {
	local myconf
	use slang || myconf="--enable-slang=no"

	econf ${myconf} || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	#In order to compile anything after, this is needed!
	#cp ${S}/config.h ${D}/${GAUL}/include/
	#is it really? (george)

	#this also is unnecesary
	#dodir /etc/env.d/
	#echo "LDPATH=/usr/lib/" >> ${D}/etc/env.d/25gaul

	use doc && (
		dodir /usr/share/${PN}
		cp -pPR tests examples ${D}/usr/share/${PN}
	)
}
