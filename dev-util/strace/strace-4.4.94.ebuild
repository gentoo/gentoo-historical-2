# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/strace/strace-4.4.94.ebuild,v 1.1 2003/04/03 20:06:17 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A usefull diagnostic, instructional, and debugging tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.wi.leidenuniv.nl/~wichert/strace/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc alpha ~hppa mips"

DEPEND="virtual/glibc >=sys-devel/autoconf-2.54"


src_compile() {
	# Compile fails with -O3 on  but works on x86, sparc untested
#	if [ "${ARCH}" == "sparc" -o "${ARCH}" == "" ]; then
#		if [ -n "${CFLAGS}" ]; then
#			CFLAGS=`echo ${CFLAGS} | sed -e 's:-O3:-O2:'`
#		fi
#	fi
	# configure is broken by default for sparc and possibly others, regen
	# from configure.in
	autoconf
	./configure --prefix=/usr || die
	emake || die
}

src_install () {
	# Can't use make install because it is stupid and
	# doesn't make leading directories before trying to
	# install. Thus, one would have to make /usr/bin
	# and /usr/man/man1 (at least).
	# So, we do it by hand.
	doman strace.1
	dobin strace 
	dobin strace-graph
	dodoc ChangeLog COPYRIGHT CREDITS NEWS PORTING README* TODO
}
