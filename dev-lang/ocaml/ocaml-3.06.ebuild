# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ocaml/ocaml-3.06.ebuild,v 1.10 2003/09/07 02:48:39 weeve Exp $

inherit flag-o-matic
filter-flags "-fstack-protector"

DESCRIPTION="fast modern type-inferring functional programming language descended from the ML (Meta Language) family"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${P}/${P}.tar.gz"

LICENSE="QPL-1.0 LGPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE="tcltk"

DEPEND="virtual/glibc
	tcltk? ( >=dev-lang/tk-3.3.3 )"

src_compile() {
	local myconf
	use tcltk || myconf="-no-tk"

	# Fix for bug #23767
	if [ "${ARCH}" = "sparc" ]
	then
		# We need a patch and to make sure it builds
		# for the right host type
		epatch ${FILESDIR}/ocaml-3.06-sparc-configure.patch
		myconf="${myconfg} -host sparc-unknown-linux-gnu"
	fi


	./configure -prefix /usr \
		-bindir /usr/bin \
		-libdir /usr/lib/ocaml \
		-mandir /usr/share/man \
		--with-pthread ${myconf} || die

	make world || die
	make opt || die
	make opt.opt || die
}

src_install() {
	make BINDIR=${D}/usr/bin \
		LIBDIR=${D}/usr/lib/ocaml \
		MANDIR=${D}/usr/share/man \
		install || die

	# silly, silly makefiles
	dosed "s:${D}::g" /usr/lib/ocaml/ld.conf

	# documentation
	dodoc Changes INSTALL LICENSE README Upgrading
}
