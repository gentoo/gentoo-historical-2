# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/diffutils/diffutils-2.8.4-r3.ebuild,v 1.10 2003/06/13 11:02:03 gmsoft Exp $

IUSE="nls build static"

inherit eutils       || die "I lost my eutils inheritence"
inherit flag-o-matic || die "I lost my flag-o-matic inheritence"

# sdiff SIGSEGVs with this on gcc-3.2.1, so take it out
# this fixes bug #13502
filter-flags "-mpowerpc-gfxopt"

S=${WORKDIR}/${P}
DESCRIPTION="Tools to make diffs and compare files"
SRC_URI="ftp://alpha.gnu.org/gnu/diffutils/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/diffutils/diffutils.html"

KEYWORDS="x86 ppc sparc ~alpha mips hppa arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	>=sys-apps/portage-2.0.47-r10
	>=sys-apps/sed-4
	nls? ( sys-devel/gettext )
	!build? ( sys-apps/texinfo sys-apps/help2man )"

RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	cd ${S}
	if [ -n "`use build`" ] ; then
		#disable texinfo building so we can remove the dep
		sed -i -e 's:SUBDIRS = doc:SUBDIRS =:' \
			Makefile.in || die "Makefile.in sed"
	fi

	# Build fails with make -j5 or greater on pentium4.  This is because
	# the jobs creating the opjects, which depend on paths.h is sheduled
	# at the same time paths.h is generated.  This patch just fix a small
	# typeo that caused this.  This closes bug #8934.
	# <azarah@gentoo.org> (14 Oct 2002)
	epatch ${FILESDIR}/${P}-Makefile-fix-typeo.patch

	# Removes waitpid() call after pclose() on piped diff stream, closing
	# bug #11728, thanks to D Wollmann <converter@dalnet-perl.org>
	epatch ${FILESDIR}/${P}-sdiff-no-waitpid.patch
}

src_compile() {
	econf --build=${CHOST} `use_enable nls` || die "econf"

	if [ "`use static`" ] ; then
		emake LDFLAGS=-static || die
	else
		emake || die
	fi
}

src_install() {
	einstall

	if [ -z "`use build`" ] ; then
		dodoc COPYING ChangeLog NEWS README
	else
		rm -rf ${D}/usr/share/info
	fi
}
