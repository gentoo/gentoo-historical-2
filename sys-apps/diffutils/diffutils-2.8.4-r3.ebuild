# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/diffutils/diffutils-2.8.4-r3.ebuild,v 1.3 2003/02/13 15:52:37 vapier Exp $

IUSE="nls build"

inherit eutils       || die "I lost my inheritence"
inherit flag-o-matic || die "I lost my inheritence"

# sdiff SIGSEGVs with this on gcc-3.2.1, so take it out
# this fixes bug #13502
filter-flags "-mpowerpc-gfxopt"

S=${WORKDIR}/${P}
DESCRIPTION="Tools to make diffs and compare files"
SRC_URI="ftp://alpha.gnu.org/gnu/diffutils/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/diffutils/diffutils.html"

KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )
	!build? ( sys-apps/texinfo sys-apps/help2man )"

RDEPEND="virtual/glibc"


src_unpack() {
	unpack ${A}

	cd ${S}
	if [ -n "`use build`" ]
	then
		#disable texinfo building so we can remove the dep
		cp Makefile.in Makefile.in.orig
		sed -e 's:SUBDIRS = doc:SUBDIRS =:' \
			Makefile.in.orig > Makefile.in
	fi

	# Build fails with make -j5 or greater on pentium4.  This is because
	# the jobs creating the opjects, which depend on paths.h is sheduled
	# at the same time paths.h is generated.  This patch just fix a small
	# typeo that caused this.  This closes bug #8934.
	# <azarah@gentoo.org> (14 Oct 2002)
	cd ${S}; epatch ${FILESDIR}/${P}-Makefile-fix-typeo.patch

	# Removes waitpid() call after pclose() on piped diff stream, closing
	# bug #11728, thanks to D Wollmann <converter@dalnet-perl.org>
	cd ${S}; epatch ${FILESDIR}/${P}-sdiff-no-waitpid.patch
}

src_compile() {
	local myconf=""
	[ -z "`use nls`" ] && myconf="--disable-nls"
	
	econf --build=${CHOST} \
		${myconf} || die
		
	emake || die
}

src_install() {
	make prefix=${D}/usr \
		datadir=${D}/usr/share \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
		
	if [ -z "`use build`" ]
	then
		dodoc COPYING ChangeLog NEWS README
	else
		rm -rf ${D}/usr/share/info
	fi
}

