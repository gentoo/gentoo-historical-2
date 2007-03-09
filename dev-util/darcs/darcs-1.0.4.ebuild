# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/darcs/darcs-1.0.4.ebuild,v 1.2 2007/03/09 04:54:36 dcoutts Exp $

DESCRIPTION="David's Advanced Revision Control System is yet another replacement for CVS"
HOMEPAGE="http://abridgegame.org/darcs"
MY_P0="${P/_rc/rc}"
MY_P="${MY_P0/_pre/pre}"
SRC_URI="http://abridgegame.org/darcs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="doc"
# disabled wxwindows use flag for now, as I got build errors

DEPEND=">=net-misc/curl-7.10.2
	virtual/mta
	>=virtual/ghc-6.2.2
	doc?  ( virtual/tetex
		dev-tex/latex2html )"
#	wxwindows?  ( dev-haskell/wxhaskell )

RDEPEND=">=net-misc/curl-7.10.2
	virtual/mta
	dev-libs/gmp"
#	wxwindows?  ( dev-haskell/wxhaskell )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf
#	myconf="`use_with wxwindows wx`"
	# distribution contains garbage files
	make clean || die "make clean failed"
	if use doc ; then
		sed -i "s:/doc:/doc/${PF}:" GNUmakefile
	else
		sed -i \
			-e 's: installdocs::' \
			-e 's:^.*BUILDDOC.*yes.*$::' \
			-e 's/^.*TARGETS.*\(darcs\.ps\|manual\).*$/:/' \
			configure
	fi
	econf ${myconf} || die "configure failed"
	echo 'INSTALLWHAT=installbin' >> autoconf.mk
	make all || die "make failed"
}

src_test() {
	make test
}

src_install() {
	make DESTDIR=${D} install || die "installation failed"
}
