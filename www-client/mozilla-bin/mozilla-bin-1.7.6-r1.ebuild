# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla-bin/mozilla-bin-1.7.6-r1.ebuild,v 1.5 2005/03/30 20:05:36 kugelfang Exp $

inherit nsplugins eutils mozilla-launcher

IUSE=""

# handle _rc versions
MY_PV=${PV/_alpha/a} 	# handle alpha
MY_PV=${MY_PV/_beta/b}	# handle beta
MY_PV=${MY_PV/_rc/rc}	# handle rc

MY_PN=${PN/-bin/}
S=${WORKDIR}/mozilla
DESCRIPTION="Mozilla Application Suite - web browser, email, HTML editor, IRC"
HOMEPAGE="http://www.mozilla.org"
# Mirrors have it in one of the following places, depending on what
# mirror you check and when you check it... :-(
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/mozilla/releases/mozilla${PV}/mozilla-i686-pc-linux-gnu-${PV}.tar.gz"
RESTRICT="nostrip"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"

DEPEND="virtual/libc"
RDEPEND="virtual/x11
	x86? (
		>=sys-libs/lib-compat-1.0-r2
		=x11-libs/gtk+-1.2*
	)
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-1.0
		>=app-emulation/emul-linux-x86-gtklibs-1.0
	)
	virtual/x11
	>=www-client/mozilla-launcher-1.28"

# This is a binary x86 package => ABI=x86
# Please keep this in future versions
# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
has_multilib_profile && ABI="x86"

src_install() {
	# Install mozilla in /opt
	dodir /opt
	mv ${S} ${D}/opt/mozilla

	# Plugin path setup (rescuing the existing plugins)
	src_mv_plugins /opt/mozilla/plugins

	# Fixing permissions
	chown -R root:root ${D}/opt/mozilla

	# mozilla-launcher-1.8 supports -bin versions
	dodir /usr/bin
	cat <<EOF >${D}/usr/bin/mozilla-bin
#!/bin/sh
# 
# Stub script to run mozilla-launcher.  We used to use a symlink here but
# OOo brokenness makes it necessary to use a stub instead:
# http://bugs.gentoo.org/show_bug.cgi?id=78890

export MOZILLA_LAUNCHER=mozilla-bin
exec /usr/libexec/mozilla-launcher "\$@"
EOF
	chmod 0755 ${D}/usr/bin/mozilla-bin

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/mozilla-bin-icon.png
	insinto /usr/share/applications
	doins ${FILESDIR}/mozilla-bin.desktop
}

pkg_preinst() {
	export MOZILLA_FIVE_HOME=${ROOT}/opt/mozilla

	# Remove the old plugins dir
	pkg_mv_plugins ${MOZILLA_FIVE_HOME}/plugins

	# Remove entire installed instance to prevent all kinds of
	# problems... see bug 44772 for example
	rm -rf "${MOZILLA_FIVE_HOME}"
}

pkg_postinst() {
	export MOZILLA_FIVE_HOME=${ROOT}/opt/mozilla

	update_mozilla_launcher_symlinks
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
