# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/esound/esound-0.2.39.ebuild,v 1.1 2008/07/16 10:33:51 remi Exp $

inherit libtool gnome.org eutils flag-o-matic

DESCRIPTION="The Enlightened Sound Daemon"
HOMEPAGE="http://www.tux.org/~ricdude/EsounD.html"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="alsa debug doc ipv6 tcpd"

# esound comes with arts support, but it hasn't been tested yet, feel free to
# submit patches/improvements
COMMON_DEPEND=">=media-libs/audiofile-0.1.5
	alsa? ( >=media-libs/alsa-lib-0.5.10b )
	doc?  ( app-text/docbook-sgml-utils )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"
#	arts? ( kde-base/arts )

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	app-admin/eselect-esd"

src_compile() {
	# Strict aliasing problem
	append-flags -fno-strict-aliasing

	econf \
		--sysconfdir=/etc/esd \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use_enable ipv6) \
		$(use_enable debug debugging) \
		$(use_enable alsa) \
		$(use_with tcpd libwrap) \
		--disable-dependency-tracking \
		|| die "Configure failed"

	emake || die "Make failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install  || die "Installation failed"
	mv "${D}/usr/bin/"{esd,esound-esd}

	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README TIPS TODO

	newconfd "${FILESDIR}/esound.conf.d" esound

	extradepend=""
	use tcpd && extradepend=" portmap"
	use alsa && extradepend="$extradepend alsasound"
	sed -e "s/@extradepend@/$extradepend/" "${FILESDIR}/esound.init.d.2" >"${T}/esound"
	doinitd "${T}/esound"
}

pkg_postinst() {
	eselect esd update --if-unset \
		|| die "eselect failed, try removing /usr/bin/esd and re-emerging."
}
