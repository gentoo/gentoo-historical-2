# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/diffutils/diffutils-2.8.7.ebuild,v 1.3 2004/05/25 11:27:02 pvdabeel Exp $

inherit eutils flag-o-matic

DESCRIPTION="Tools to make diffs and compare files"
HOMEPAGE="http://www.gnu.org/software/diffutils/diffutils.html"
SRC_URI="ftp://alpha.gnu.org/gnu/diffutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86 ppc ~hppa ~ppc64"
IUSE="nls build static"

DEPEND="virtual/glibc
	>=sys-apps/portage-2.0.47-r10
	>=sys-apps/sed-4
	nls? ( sys-devel/gettext )
	!build? ( sys-apps/texinfo sys-apps/help2man )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	cd ${S}
	if use build ; then
		#disable texinfo building so we can remove the dep
		sed -i -e 's:SUBDIRS = doc:SUBDIRS =:' \
			Makefile.in || die "Makefile.in sed"
	fi

	# Removes waitpid() call after pclose() on piped diff stream, closing
	# bug #11728, thanks to D Wollmann <converter@dalnet-perl.org>
	epatch ${FILESDIR}/diffutils-2.8.4-sdiff-no-waitpid.patch

	# the manpage for diff is better provided by the man-pages package, so
	# we disable it here
	epatch ${FILESDIR}/${P}-no-manpage.patch
}

src_compile() {
	econf --build=${CHOST} `use_enable nls` || die "econf"

	if use static ; then
		emake LDFLAGS=-static || die
	else
		emake || die
	fi
}

src_install() {
	einstall || die

	if ! use build ; then
		dodoc ChangeLog NEWS README
	else
		rm -rf ${D}/usr/share/info
	fi
}
