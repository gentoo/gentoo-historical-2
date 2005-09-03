# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/cedega/cedega-4.4.1.ebuild,v 1.3 2005/09/03 22:08:26 eradicator Exp $

MY_P="cedega_${PV}-1.i386"
DESCRIPTION="Cedega replaces WineX, a distribution of Wine with enhanced DirectX for gaming"
HOMEPAGE="http://www.transgaming.com/"
SRC_URI="${MY_P}.tgz"

LICENSE="Aladdin"
SLOT="3"
KEYWORDS="-* amd64 x86"
IUSE="cups opengl"
RESTRICT="fetch"

RDEPEND="virtual/x11
	opengl? ( virtual/opengl )
	>=sys-libs/ncurses-5.2
	cups? ( net-print/cups )
	>=media-libs/freetype-2.0.0
	amd64? ( app-emulation/emul-linux-x86-xlibs
	         app-emulation/emul-linux-x86-soundlibs )"

pkg_nofetch() {
	einfo "Please download the appropriate Cedega archive (${MY_P}.tgz)"
	einfo "from ${HOMEPAGE} (requires a Transgaming subscription)"
	einfo
	einfo "Then put the file in ${DISTDIR}"
}

src_install() {
	mv "${WORKDIR}"/usr "${D}"/ || die "mv usr"
}

pkg_postinst() {
	einfo "Run /usr/bin/cedega to start cedega as any non-root user."
	einfo "This is a wrapper-script which will take care of creating"
	einfo "an initial environment and do everything else."
	einfo ""
	einfo "Optionally, if you have binfmt_misc compiled into your kernel,"
	einfo "you can add the following to /etc/sysctl.conf to allow direct"
	einfo "excecution of Windows binaries through the cedega wrapper:"
	einfo ""
	einfo "  fs.binfmt_misc.register = :WINEXE:M::MZ::/usr/bin/cedega:"
	einfo ""
	einfo "You will also need to mount the /proc/sys/fs/binfmt_misc"
	einfo "file system in order for this to work.  You can add the following"
	einfo "line into your /etc/fstab file:"
	einfo ""
	einfo "  none  /proc/sys/fs/binfmt_misc  binfmt_misc  defaults 0 0"
	einfo ""
	einfo "Note: Binaries will still need excecutable permissions to run."
	einfo "Note: If binfmt_misc is compiled as a module, make sure you"
	einfo "have it loaded on startup by adding it to"
	einfo "/etc/modules.autoload.d/<your kernel version>"
}
