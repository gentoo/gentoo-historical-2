# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/jd/jd-2.0.2_p080919.ebuild,v 1.1 2008/09/20 02:37:04 matsuu Exp $

inherit eutils autotools

MY_P="${P/_p/-}"
MY_P="${MY_P/_beta/-}"

DESCRIPTION="gtk2 based 2ch browser written in C++"
HOMEPAGE="http://jd4linux.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/jd4linux/32951/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa gnome gnutls"
#IUSE="alsa gnome gnutls migemo"

RDEPEND=">=dev-cpp/gtkmm-2.8
	>=dev-libs/glib-2
	x11-misc/xdg-utils
	alsa? ( >=media-libs/alsa-lib-1 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	!gnome? (
		x11-libs/libSM
		x11-libs/libICE
	)
	gnutls? ( >=net-libs/gnutls-1.2 )
	!gnutls? ( >=dev-libs/openssl-0.9 )"
#	migemo? ( app-text/cmigemo )

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	local myconf="--with-xdgopen"

	# use gnomeui sm instead of Xorg SM/ICE
	if use gnome ; then
		myconf="${myconf} --with-sessionlib=gnomeui"
	else
		myconf="${myconf} --with-sessionlib=xsmp"
	fi

	if use gnutls ; then
		myconf="${myconf} --without-openssl"
	else
		myconf="${myconf} --with-openssl"
	fi

	#if use migemo ; then
	#	myconf="${myconf} --with-migemo --with-migemodict=/usr/share/migemo/migemo-dict"
	#else
	#	myconf="${myconf} --without-migemo"
	#fi

	econf \
		$(use_with alsa) \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon ${PN}.png
	domenu ${PN}.desktop
	dodoc AUTHORS ChangeLog NEWS README
}
