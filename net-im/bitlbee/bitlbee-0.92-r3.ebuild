# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/bitlbee/bitlbee-0.92-r3.ebuild,v 1.4 2007/04/28 17:34:27 swegener Exp $

inherit eutils toolchain-funcs

DESCRIPTION="irc to IM gateway that support multiple IM protocols"
HOMEPAGE="http://www.bitlbee.org/"
SRC_URI="http://get.bitlbee.org/src/${P}.tar.gz
		 aimextras? ( http://get.bitlbee.org/patches/hanji/all.patch )
		 msnextras? ( http://www.bitlbee.be/andy/bitlbee-0.92-msn6.akke.patch )
		 gtalk? ( http://get.bitlbee.org/patches/bitlbee-jabberserver.patch )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~ia64 ~amd64"
IUSE="debug jabber gtalk msn oscar yahoo flood gnutls openssl aimextras msnextras"

DEPEND=">=dev-libs/glib-2.0
	msn? ( gnutls? ( net-libs/gnutls )
		   openssl? ( dev-libs/openssl ) )
	jabber? ( gnutls? ( net-libs/gnutls )
			  openssl? ( dev-libs/openssl ) )"

no_flags_die() {
	eerror ""
	eerror "Please choose a protocol or protocols to use with"
	eerror "bitlbee by enabling the useflag for the protocol"
	eerror "desired."
	eerror ""
	eerror " Valid useflags are;"
	eerror " jabber, msn, oscar and yahoo"
	die "No IM protocols selected!"
}

pkg_setup() {
	elog "Note: as of bitlbee-0.82-r1, all protocols are useflags."
	elog "      Make sure you've enabled the flags you want."
	elog ""
	elog "To use jabber over SSL or MSN Messenger, you will need to enable"
	elog "either the gnutls or openssl useflags."

	if use aimextras; then
		elog ""
		elog "NOTE: This is a patch for extra AIM functionality that is NOT"
		elog "      supported by upstream.  Please do not report any problems"
		elog "      to them about this as they will be ignored."
	fi

	if use msnextras; then
		elog ""
		elog "NOTE: This is a patch for extra MSN functionality that is NOT"
		elog "      supported by upstream.  Please do not report any problems"
		elog "      to them about this as they will be ignored."
	fi

	if use gtalk; then
	    elog ""
		elog "NOTE: This is a patch for Google Talk ability over Jabber"
		elog "      It is provided by ludvig.ericson@gmail.com - do not"
		elog "      mail any questions to the Portage buglist."
	fi

	use jabber || use msn || use oscar || use yahoo || no_flags_die
}

src_unpack() {
	unpack ${P}.tar.gz

	# Patch the default xinetd file to add/adjust values to Gentoo defaults
	cd ${S}/doc && epatch ${FILESDIR}/${PN}-0.80-xinetd.patch
	cd ${S} && epatch ${FILESDIR}/${PN}-gentoohack.patch

	if use aimextras; then
		epatch ${DISTDIR}/all.patch
	fi

	if use msnextras; then
		epatch ${DISTDIR}/${P}-msn6.akke.patch
	fi

	if use gtalk; then
	    epatch ${DISTDIR}/bitlbee-jabberserver.patch
	fi

}

src_compile() {
	# setup useflags
	local myconf
	use debug && myconf="${myconf} --debug=1"
	use msn || myconf="${myconf} --msn=0 "
	use jabber || myconf="${myconf} --jabber=0"
	use oscar || myconf="${myconf} --oscar=0"
	use yahoo || myconf="${myconf} --yahoo=0"
	use gnutls && myconf="${myconf} --ssl=gnutls"
	use openssl && myconf="${myconf} --ssl=openssl"
	use flood && myconf="${myconf} --flood=1"

	if ( ( use jabber && ( use gnutls || use openssl ) ) || use msn ) && !gnutls && !openssl; then
		myconf="${myconf} --ssl=bogus"
	fi

	econf --datadir=/usr/share/bitlbee --etcdir=/etc/bitlbee ${myconf} \
		|| die "econf failed"

	emake || die "make failed"

	# make bitlbeed forking server
	cd utils
	$(tc-getCC) ${CFLAGS} bitlbeed.c -o bitlbeed || die "bitlbeed failed to compile"
}

src_install() {
	dodir /var/lib/bitlbee
	make install DESTDIR=${D} || die "install failed"
	make install-etc DESTDIR=${D} || die "install failed"
	make install-doc DESTDIR=${D} || die "install failed"
	keepdir /var/lib/bitlbee

	dodoc doc/{AUTHORS,CHANGES,CREDITS,FAQ,README,TODO,user-guide.txt}
	dohtml -A sgml doc/*.sgml
	dohtml -A xml doc/*.xml
	dohtml -A xsl doc/*.xsl
	dohtml doc/*.html

	doman doc/bitlbee.8 doc/bitlbee.conf.5

	dobin utils/bitlbeed

	insinto /etc/xinetd.d
	newins doc/bitlbee.xinetd bitlbee

	newinitd ${FILESDIR}/bitlbeed.init bitlbeed || die

	newconfd ${FILESDIR}/bitlbeed.confd bitlbeed || die

	dodir /var/run/bitlbeed
	keepdir /var/run/bitlbeed

	dodir /usr/share/bitlbee
	cp ${S}/utils/* ${D}/usr/share/bitlbee
	rm ${D}/usr/share/bitlbee/bitlbeed*

}

pkg_postinst() {
	chown nobody:nobody ${ROOT}/var/lib/bitlbee
	chmod 700 ${ROOT}/var/lib/bitlbee
	elog "The utils included in bitlbee (other than bitlbeed) are now"
	elog "located in /usr/share/bitlbee"
	elog
	elog "NOTE: The irssi script is no longer provided by bitlbee."
}
