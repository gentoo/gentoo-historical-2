# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/grep/grep-2.5.1-r1.ebuild,v 1.11 2003/09/21 17:17:06 vapier Exp $


IUSE="nls build"

inherit gnuconfig

S=${WORKDIR}/${P}
DESCRIPTION="GNU regular expression matcher"
SRC_URI="ftp://prep.ai.mit.edu/gnu/${PN}/${P}.tar.gz
	ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/grep/grep.html"

KEYWORDS="x86 amd64 ppc sparc alpha mips hppa arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	echo ${PROFILE_ARCH}
	if [ "${ARCH}" = "sparc" -a "${PROFILE_ARCH}" = "sparc" ]
	then
		cd ${S}
		epatch ${FILESDIR}/gentoo-sparc32-dfa.patch || die
	fi
}

src_compile() {

	# Fix configure scripts to detect linux-mips
	gnuconfig_update

	local myconf=""
	use nls || myconf="--disable-nls"

	econf --bindir=/bin \
		--disable-perl-regexp \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	einstall bindir=${D}/bin || die "einstall failed"

	if use build; then
		rm -rf ${D}/usr/share
	else
		dodoc AUTHORS COPYING ChangeLog NEWS README THANKS TODO
	fi
}

