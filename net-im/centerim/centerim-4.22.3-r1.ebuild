# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/centerim/centerim-4.22.3-r1.ebuild,v 1.2 2008/03/28 21:16:00 maekke Exp $

inherit eutils

PROTOCOL_IUSE="aim gadu icq irc jabber lj msn rss yahoo"
IUSE="${PROTOCOL_IUSE} bidi nls ssl crypt jpeg otr"

DESCRIPTION="CenterIM is a fork of CenterICQ - a ncurses ICQ/Yahoo!/AIM/IRC/MSN/Jabber/GaduGadu/RSS/LiveJournal Client"
if [[ ${PV} = *_p* ]] # is this a snaphot?
then
	SRC_URI="http://www.centerim.org/download/snapshots/${PN}-${PV/*_p/}.tar.gz"
else
	SRC_URI="http://www.centerim.org/download/releases/${P}.tar.gz"
fi
HOMEPAGE="http://www.centerim.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND=">=sys-libs/ncurses-5.2
	bidi? ( dev-libs/fribidi )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	jpeg? ( media-libs/jpeg )
	jabber? (
		otr? ( net-libs/libotr )
		crypt? ( >=app-crypt/gpgme-1.0.2 )
	)
	msn? (
		net-misc/curl
		dev-libs/openssl
	)"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

S="${WORKDIR}"/${P/_p*}

check_protocol_iuse() {
	local flag

	for flag in ${PROTOCOL_IUSE}
	do
		use ${flag} && return 0
	done

	return 1
}

pkg_setup() {
	if ! check_protocol_iuse
	then
		eerror
		eerror "Please activate at least one of the following protocol USE flags:"
		eerror "${PROTOCOL_IUSE}"
		eerror
		die "Please activate at least one protocol USE flag!"
	fi

	if use msn && ! built_with_use net-misc/curl ssl
	then
		eerror
		eerror "As of right now, the msn use flags requires curl to be built"
		eerror "with SSL support. Make sure ssl is in your USE flags and"
		eerror "re-emerge net-misc/curl."
		eerror
		die "net-misc/curl dependencie issue"
	fi

	if use otr && ! use jabber
	then
		eerror
		eerror "Support for OTR is only supported with Jabber!"
		eerror
		die "Support for OTR is only supported with Jabber!"
	fi

	if use gadu && ! use jpeg
	then
		ewarn
		ewarn "You need jpeg support to be able to register Gadu-Gadu accounts!"
		ewarn
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-url-escape.patch
}

src_compile() {
	econf \
		$(use_with ssl) \
		$(use_enable aim) \
		$(use_with bidi fribidi) \
		$(use_with jpeg libjpeg) \
		$(use_with otr libotr) \
		$(use_enable gadu gg) \
		$(use_enable icq) \
		$(use_enable irc) \
		$(use_enable jabber) \
		$(use_enable lj) \
		$(use_enable msn) \
		$(use_enable nls locales-fix) \
		$(use_enable nls) \
		$(use_enable rss) \
		$(use_enable yahoo) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog FAQ README THANKS TODO
}
