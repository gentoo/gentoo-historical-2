# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/efsd/efsd-0.0.1.20030629.ebuild,v 1.2 2003/07/18 22:35:08 vapier Exp $

inherit enlightenment flag-o-matic

DESCRIPTION="daemon that provides commonly needed file system functionality to clients"
HOMEPAGE="http://www.enlightenment.org/pages/efsd.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~mips ~hppa ~arm"

DEPEND="${DEPEND}
	dev-lang/perl"
RDEPEND="${DEPEND}
	app-admin/fam-oss
	>=dev-libs/libxml2-2.3.10
	>=dev-db/edb-1.0.3.2003*"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	gettext_modify
}

src_compile() {
	env PATH="${T}:${PATH}" WANT_AUTOCONF_2_5=1 NOCONFIGURE=yes ./autogen.sh || die
	use alpha && append-flags -fPIC
	econf --with-gnu-ld || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml -r doc
	docinto example
	doins example/*
}
