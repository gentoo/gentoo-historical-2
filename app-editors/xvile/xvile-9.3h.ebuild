# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xvile/xvile-9.3h.ebuild,v 1.9 2004/06/24 22:04:34 agriffis Exp $

S=${WORKDIR}/vile-9.3
DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="http://www.clark.net/pub/dickey/vile/vile.html"
SRC_URI="ftp://ftp.phred.org/pub/vile/vile-9.3.tgz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3a.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3b.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3c.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3d.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3e.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3f.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3g.patch.gz
	ftp://ftp.phred.org/pub/vile/patches/vile-9.3h.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha"
IUSE="perl"

DEPEND="virtual/glibc
	sys-devel/flex
	virtual/x11
	=app-editors/vile-9.3h"
RDEPEND="perl? ( dev-lang/perl )"

src_unpack() {
	unpack vile-9.3.tgz

	cd ${S}
	local i
	for i in a b c d e f g h
	do
		gunzip -c ${DISTDIR}/vile-9.3$i.patch.gz | patch -p1
	done
}

src_compile() {
	local myconf
	use perl && myconf="--with-perl"

	./configure --prefix=/usr --host=${CHOST} \
		--mandir=/usr/share/man \
		--with-x \
		$myconf || die

	emake || die
}

src_install() {
	dobin xvile
	make DESTDIR=${D} install || die
	dodoc CHANGES* MANIFEST INSTALL README* doc/*
}
