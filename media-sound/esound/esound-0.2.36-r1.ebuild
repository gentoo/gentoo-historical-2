# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/esound/esound-0.2.36-r1.ebuild,v 1.19 2006/09/24 15:09:56 seemant Exp $

inherit libtool gnome.org eutils autotools

DESCRIPTION="The Enlightened Sound Daemon"
HOMEPAGE="http://www.tux.org/~ricdude/EsounD.html"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ~ppc-macos ppc64 sh sparc x86 ~x86-fbsd"
IUSE="alsa debug ipv6 static tcpd"

# esound comes with arts support, but it hasn't been tested yet, feel free to
# submit patches/improvements
DEPEND=">=media-libs/audiofile-0.1.5
	alsa? ( >=media-libs/alsa-lib-0.5.10b )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"
#	arts? ( kde-base/arts )

RDEPEND="${DEPEND}
	!app-admin/eselect-esd"

src_unpack() {

	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-0.2.32-amd64.patch
	# please note, this is a conditional, version specific patch!!!
	# when bumping avoid bugs like #103969
	use ppc-macos && epatch ${FILESDIR}/${P}-ppc-macos.patch

	epatch "${FILESDIR}/${P}-mode_t.patch"
	epatch "${FILESDIR}/${P}-asneeded.patch"

	export WANT_AUTOMAKE=1.8
	eautomake

	elibtoolize
}

src_compile() {
	local myconf="--sysconfdir=/etc/esd $(use_enable ipv6) \
		$(use_enable static) $(use_enable debug debugging) $(use_enable alsa) \
		$(use_with tcpd libwrap)"

	econf $myconf || die "Configure failed"

	emake || die "Make failed"
}

src_install() {

	make DESTDIR="${D}" install	 || die "Installation failed"

	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README TIPS TODO

	[[ -d "docs/html" ]] && dohtml -r docs/html/*

	newconfd ${FILESDIR}/esound.conf.d esound

	extradepend=""
	use tcpd && extradepend=" portmap"
	use alsa && extradepend="$extradepend alsasound"
	sed -e "s/@extradepend@/$extradepend/" ${FILESDIR}/esound.init.d >${T}/esound
	doinitd ${T}/esound

}
