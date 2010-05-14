# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/isight-firmware-tools/isight-firmware-tools-1.5.92.ebuild,v 1.1 2010/05/14 17:53:21 eva Exp $

EAPI="2"

inherit eutils multilib versionator

MY_MAJORV="$(get_version_component_range 1).6"
DESCRIPTION="Extract, load or export firmware for the iSight webcams"
HOMEPAGE="http://bersace03.free.fr/ift/"
SRC_URI="http://launchpad.net/${PN}/main/${MY_MAJORV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.14
	virtual/libusb:0
	dev-libs/libgcrypt
	>=sys-fs/udev-149"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	sys-apps/texinfo"

src_prepare() {
	# Fix rules for recent udev versions, bug #316027
	sed 's/SYSFS/ATTR/g' -i src/isight.rules.in.in || die "sed 1 failed"

	# Fix multilib support
	sed "s:/lib/firmware:/$(get_libdir)/firmware:" \
		-i src/isight.rules.in.in || die "sed 2 failed"

	# Fix build with -O0, bug #221325
	epatch "${FILESDIR}/${PN}-1.5.90-build-O0.patch"
}

src_configure() {
	# https://bugs.launchpad.net/isight-firmware-tools/+bug/243255
	econf --docdir=/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	mv "${D}"/etc/udev/rules.d/isight.rules "${D}"/etc/udev/rules.d/70-isight.rules
	rm -f "${D}/usr/share/doc/${PF}/HOWTO"
	dodoc AUTHORS ChangeLog HOWTO NEWS README || die "dodoc failed"
}

pkg_postinst() {
	elog "You need to extract your firmware prior to being able to loading it"
	elog "ift-extract --apple-driver /macos/System/Library/Extensions/IOUSBFamily.kext/Contents/PlugIns/AppleUSBVideoSupport.kext/Contents/MacOS/AppleUSBVideoSupport"
	elog "If you do not have OSX you can get AppleUSBVideoSupport from"
	elog "http://www.mediafire.com/?81xtkqyttjt"
}
