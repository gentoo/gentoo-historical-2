# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xfs/xfs-1.0.4.ebuild,v 1.8 2007/07/02 14:03:34 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X font server"

KEYWORDS="alpha amd64 arm hppa mips ~ppc ppc64 s390 sh ~sparc x86"
IUSE="ipv6"

RDEPEND="x11-apps/ttmkfdir
	x11-libs/libFS
	x11-libs/libXfont"
DEPEND="${RDEPEND}
	x11-proto/fontsproto"

CONFIGURE_OPTIONS="$(use_enable ipv6) --libdir=/etc"

pkg_setup() {
	enewgroup xfs 33
	enewuser xfs 33 -1 /etc/X11/fs xfs
}

src_unpack() {
	x-modular_unpack_source
	x-modular_patch_source

	sed -i -e "s:^configdir =.*:configdir = \$(sysconfdir)/X11/fs:g" \
		"${S}"/Makefile.am

	x-modular_reconf_source
}

src_install() {
	x-modular_src_install

	insinto /etc/X11/fs
	newins "${FILESDIR}"/xfs.config config
	newinitd "${FILESDIR}"/xfs.start xfs
	newconfd "${FILESDIR}"/xfs.conf.d xfs
}
