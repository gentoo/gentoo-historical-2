# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/sharutils/sharutils-4.2.1-r6.ebuild,v 1.8 2004/09/29 14:16:26 vapier Exp $

inherit eutils

DESCRIPTION="Tools to deal with shar archives"
HOMEPAGE="http://www.gnu.org/software/sharutils/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 ppc64"
IUSE="nls"

DEPEND="sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.10.35 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch

	cd ${S}/po
	mv nl.po nl.po.orig
	sed -e 's/aangemaakt/aangemaakt\\n/' nl.po.orig > nl.po
	mv pt.po pt.po.orig
	sed -e 's/de %dk/de %dk\\n/' pt.po.orig > pt.po
}

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"

	./configure --host=${CHOST} --prefix=/usr ${myconf} || die
	make ${MAKEOPTS} localedir=/usr/share/locale || die
}

src_install() {
	make \
		prefix=${D}/usr \
		localedir=${D}/usr/share/locale \
		infodir=${D}/usr/share/info \
		install || die

	doman doc/*.[15]
	#Remove some strange locals
	cd ${D}/usr/share/locale
	for i in *.
	do
	  rm -rf ${i}
	done
	rm -rf ${D}/usr/lib

	cd ${S}
	dodoc AUTHORS BACKLOG ChangeLog ChangeLog.OLD \
		NEWS README README.OLD THANKS TODO
}
