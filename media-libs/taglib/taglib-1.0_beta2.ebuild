# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.0_beta2.ebuild,v 1.5 2004/01/04 15:19:23 weeve Exp $
inherit flag-o-matic

LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"
DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://ktown.kde.org/~wheeler/taglib"
SRC_URI="http://ktown.kde.org/~wheeler/${PN}/${PN}-0.96.tar.gz"
S=${WORKDIR}/${PN}-0.96
SLOT=0

replace-flags "-O3 -O2"

src_compile()
{
	cd ${S}
	rm -rf autom4te.cache
	export WANT_AUTOCONF_2_5=1
	export WANT_AUTOMAKE=1.7
	aclocal && autoconf && automake
	econf
	emake
}

src_install()
{
	make install DESTDIR=${D} destdir=${D}
}
