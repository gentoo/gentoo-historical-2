# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/psmisc/psmisc-22.15.ebuild,v 1.1 2012/01/28 06:09:00 ssuominen Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A set of tools that use the proc filesystem"
HOMEPAGE="http://psmisc.sourceforge.net/"
SRC_URI="mirror://sourceforge/psmisc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="ipv6 nls selinux X"

RDEPEND=">=sys-libs/ncurses-5.7-r7
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6b
	nls? ( sys-devel/gettext )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-COMM_LEN-to-18.patch

	if ! use nls; then
		# http://bugs.gentoo.org/193920
		sed -i \
			-e '/AM_GNU_GETTEXT/d' -e 's:po/Makefile.in::' \
			-e '/SUBDIRS/s:po::' -e 's:@LIBINTL@::' \
			configure.ac {.,src}/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	# the nls looks weird, but it's because we actually delete the nls stuff
	# above when USE=-nls.  this should get cleaned up so we dont have to patch
	# it out, but until then, let's not confuse users ... #220787
	econf \
		$(use_enable selinux) \
		$(use_enable ipv6) \
		$(use nls && use_enable nls)
}

src_compile() {
	# peekfd is a fragile crap hack #330631
	nonfatal emake -C src peekfd || touch src/peekfd{.o,}
	emake
}

src_install() {
	default

	use X || rm "${ED}"/usr/bin/pstree.x11

	[[ -s ${ED}/usr/bin/peekfd ]] || rm -f "${ED}"/usr/bin/peekfd
	[[ -e ${ED}/usr/bin/peekfd ]] || rm -f "${ED}"/usr/share/man/man1/peekfd.1

	# fuser is needed by init.d scripts
	dodir /bin
	mv -vf "${ED}"/usr/bin/fuser "${ED}"/bin/ || die
}
