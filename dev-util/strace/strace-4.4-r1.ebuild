# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/strace/strace-4.4-r1.ebuild,v 1.1 2003/01/01 03:43:17 vapier Exp $

# NOTE: For some reason, upstream has changed the naming scheme
# for the tarballs to something quite lame:
# strace_version-revision.tar.gz
# This makes it difficult for us to deal with, because portage
# is supposed to glean the package version information from the
# filename of the ebuild. Grr
# Thus, *MAINTAINER*: change the *revision* in the SRC_URI below
# by hand. Sorry, couldn't think of a better way.
#  - Jon Nelson, 27 Apr 2002

DESCRIPTION="A usefull diagnostic, instructional, and debugging tool"
SRC_URI="mirror://sourceforge/strace/strace_4.4-1.tar.gz"
HOMEPAGE="http://www.wi.leidenuniv.nl/~wichert/strace/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
IUSE="static"

DEPEND="virtual/glibc
	sys-devel/autoconf"

src_compile() {
	# Compile fails with -O3 on  but works on x86, sparc untested
	if [ "${ARCH}" == "sparc" -o "${ARCH}" == "" ]; then
		if [ -n "${CFLAGS}" ]; then
			CFLAGS=`echo ${CFLAGS} | sed -e 's:-O3:-O2:'`
		fi
	fi

	# configure is broken by default for sparc and possibly others, regen
	# from configure.in
	use static && export LDFLAGS="${LDFLAGS} -static"
	autoconf
	./configure --prefix=/usr || die
	emake || die
}

src_install() {
	doman strace.1
	dobin strace strace-graph
	dodoc ChangeLog COPYRIGHT CREDITS NEWS PORTING README* TODO
}
