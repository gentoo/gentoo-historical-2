# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mutt/mutt-1.5.19-r1.ebuild,v 1.2 2009/06/19 08:05:39 grobian Exp $

inherit eutils flag-o-matic autotools

PATCHSET_REV=""

# note: latest sidebar patches can be found here:
# http://www.lunar-linux.org/index.php?option=com_content&task=view&id=44
SIDEBAR_PATCH_N="patch-1.5.19.sidebar.20090522.txt"

DESCRIPTION="a small but very powerful text-based mail client"
HOMEPAGE="http://www.mutt.org"
SRC_URI="ftp://ftp.mutt.org/mutt/devel/${P}.tar.gz
	!vanilla? (
		!sidebar? (
			mirror://gentoo/${P}-gentoo-patches${PATCHSET_REV}.tar.bz2
			http://dev.gentoo.org/~grobian/distfiles/${P}-gentoo-patches${PATCHSET_REV}.tar.bz2
		)
	)
	sidebar? (
		http://www.lunar-linux.org/~tchan/mutt/${SIDEBAR_PATCH_N}
	)"
IUSE="berkdb crypt debug gdbm gnutls gpgme idn imap mbox nls nntp pop qdbm sasl
sidebar smime smtp ssl vanilla"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
RDEPEND=">=sys-libs/ncurses-5.2
	qdbm?    ( dev-db/qdbm )
	!qdbm?   (
		gdbm?  ( sys-libs/gdbm )
		!gdbm? ( berkdb? ( >=sys-libs/db-4 ) )
	)
	imap?    (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	pop?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	smtp?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	idn?     ( net-dns/libidn )
	gpgme?   ( >=app-crypt/gpgme-0.9.0 )
	smime?   ( >=dev-libs/openssl-0.9.6 )
	app-misc/mime-types"
DEPEND="${RDEPEND}
	net-mail/mailbase
	!vanilla? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		|| ( www-client/lynx www-client/w3m www-client/elinks )
	)"

PATCHDIR="${WORKDIR}"/${P}-gentoo-patches${PATCHSET_REV}

src_unpack() {
	unpack ${A//${SIDEBAR_PATCH_N}}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-libgnutls-test-15c662a95b91.patch
	# CVE-2009-1390 http://thread.gmane.org/gmane.comp.security.oss.general/1847
	epatch "${FILESDIR}"/${P}-mutt_ssl-3af7e8af1983-dc9ec900c657.patch
	epatch "${FILESDIR}"/${P}-mutt-gnutls-7d0583e0315d-0b13183e40e0.patch

	if use !vanilla && use !sidebar ; then
		use nntp || rm "${PATCHDIR}"/06-nntp.patch
		for p in "${PATCHDIR}"/*.patch ; do
			epatch "${p}"
		done
	fi

	if use sidebar ; then
		use vanilla || \
			ewarn "The sidebar patch is only applied to a vanilla mutt tree."
		epatch "${DISTDIR}"/${SIDEBAR_PATCH_N}
	fi

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	declare myconf="
		$(use_enable nls) \
		$(use_enable gpgme) \
		$(use_enable imap) \
		$(use_enable pop) \
		$(use_enable smtp) \
		$(use_enable crypt pgp) \
		$(use_enable smime) \
		$(use_enable debug) \
		$(use_with idn) \
		--with-curses \
		--sysconfdir=/etc/${PN} \
		--with-docdir=/usr/share/doc/${PN}-${PVR} \
		--with-regex \
		--enable-nfs-fix --enable-external-dotlock \
		$(use_with !nntp mixmaster) \
		--with-exec-shell=/bin/sh"

	case $CHOST in
		*-darwin7)
			# locales are broken on Panther
			myconf="${myconf} --enable-locales-fix --without-wc-funcs"
			myconf="${myconf} --disable-fcntl --enable-flock"
		;;
		*-solaris*)
			# Solaris has no flock in the standard headers
			myconf="${myconf} --enable-fcntl --disable-flock"
		;;
		*)
			myconf="${myconf} --disable-fcntl --enable-flock"
		;;
	esac

	# See Bug #22787
	unset WANT_AUTOCONF_2_5 WANT_AUTOCONF

	# mutt prioritizes gdbm over bdb, so we will too.
	# hcache feature requires at least one database is in USE.
	if use qdbm; then
		myconf="${myconf} --enable-hcache \
		--with-qdbm --without-gdbm --without-bdb"
	elif use gdbm ; then
		myconf="${myconf} --enable-hcache \
			--without-qdbm --with-gdbm --without-bdb"
	elif use berkdb; then
		myconf="${myconf} --enable-hcache \
			--without-gdbm --without-qdbm --with-bdb"
	else
		myconf="${myconf} --disable-hcache \
			--without-qdbm --without-gdbm --without-bdb"
	fi

	# there's no need for gnutls, ssl or sasl without socket support
	if use pop || use imap || use smtp ; then
		if use gnutls; then
			myconf="${myconf} --with-gnutls"
		elif use ssl; then
			myconf="${myconf} --with-ssl"
		fi
		# not sure if this should be mutually exclusive with the other two
		myconf="${myconf} $(use_with sasl)"
	else
		myconf="${myconf} --without-gnutls --without-ssl --without-sasl"
	fi

	# See Bug #11170
	case ${ARCH} in
		alpha|ppc) replace-flags "-O[3-9]" "-O2" ;;
	esac

	if use mbox; then
		myconf="${myconf} --with-mailpath=/var/spool/mail"
	else
		myconf="${myconf} --with-homespool=Maildir"
	fi

	if use !vanilla && use !sidebar ; then
		# rr.compressed patch
		myconf="${myconf} --enable-compressed"

		# nntp patch applied conditionally, so avoid QA warning when doing
		# --disable-nntp while patch not being applied, bug #262069
		use nntp && myconf="${myconf} --enable-nntp"
	fi

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	find "${D}"/usr/share/doc -type f | grep -v "html\|manual" | xargs gzip
	if use mbox; then
		insinto /etc/mutt
		newins "${FILESDIR}"/Muttrc.mbox Muttrc
	else
		insinto /etc/mutt
		doins "${FILESDIR}"/Muttrc
	fi

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${D}"/etc/${PN}/mime.types
	dosym /etc/mime.types /etc/${PN}/mime.types

	# charset.alias is installed by libiconv
	rm -f "${D}"/usr/lib/charset.alias
	rm -f "${D}"/usr/share/locale/locale.alias

	dodoc BEWARE COPYRIGHT ChangeLog NEWS OPS* PATCHES README* TODO VERSION
}

pkg_postinst() {
	echo
	elog "If you are new to mutt you may want to take a look at"
	elog "the Gentoo QuickStart Guide to Mutt E-Mail:"
	elog "   http://www.gentoo.org/doc/en/guide-to-mutt.xml"
	echo
}
