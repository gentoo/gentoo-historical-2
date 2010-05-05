# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/isight-firmware-tools/isight-firmware-tools-1.5.90.ebuild,v 1.2 2010/05/05 22:07:00 eva Exp $

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
	dev-libs/libgcrypt"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	sys-apps/texinfo"

src_prepare() {
	# Fix multilib support
	sed "s:/lib/firmware:/$(get_libdir)/firmware:" \
		-i src/isight.rules.in.in || die "sed failed"

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_configure() {
	# https://bugs.launchpad.net/isight-firmware-tools/+bug/243255
	econf --docdir="${ROOT}/usr/share/doc/${PF}"
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
