# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-2.0.14.ebuild,v 1.5 2010/01/26 01:03:54 jer Exp $

EAPI="2"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${P}.tar.bz2"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="adns bzip2 caps doc ldap nls openct pcsc-lite static selinux smartcard"

COMMON_DEPEND_LIBS="
	>=dev-libs/pth-1.3.7
	>=dev-libs/libgcrypt-1.4
	>=dev-libs/libksba-1.0.2
	>=dev-libs/libgpg-error-1.7
	>=net-misc/curl-7.10
	adns? ( >=net-libs/adns-1.4 )
	bzip2? ( app-arch/bzip2 )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )
	openct? ( >=dev-libs/openct-0.5.0 )
	smartcard? ( =virtual/libusb-0* )
	ldap? ( net-nds/openldap )"
COMMON_DEPEND_BINS="app-crypt/pinentry"

# existence of bins are checked during configure
DEPEND="${COMMON_DEPEND_LIBS}
	${COMMON_DEPEND_BINS}
	=dev-libs/libassuan-1*
	nls? ( sys-devel/gettext )
	doc? ( sys-apps/texinfo )"

RDEPEND="!static? ( ${COMMON_DEPEND_LIBS} )
	${COMMON_DEPEND_BINS}
	virtual/mta
	!app-crypt/gpg-agent
	!<=app-crypt/gnupg-2.0.1
	selinux? ( sec-policy/selinux-gnupg )
	nls? ( virtual/libintl )"

src_configure() {
	# 'USE=static' support was requested:
	# gnupg1: bug #29299
	# gnupg2: bug #159623
	use static && append-ldflags -static

	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-symcryptrun \
		--enable-gpg \
		--enable-gpgsm \
		--enable-agent \
		$(use_with adns) \
		$(use_enable bzip2) \
		$(use_enable smartcard scdaemon) \
		$(use_enable nls) \
		$(use_enable ldap) \
		$(use_with caps capabilities) \
		CC_FOR_BUILD=$(tc-getBUILD_CC)
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS README THANKS TODO VERSION

	mv "${D}usr/share/gnupg/help"* "${D}usr/share/doc/${PF}"
	ecompressdir "/usr/share/doc/${P}"

	dosym gpg2 /usr/bin/gpg
	dosym gpgv2 /usr/bin/gpgv
	dosym gpg2keys_hkp /usr/libexec/gpgkeys_hkp
	dosym gpg2keys_finger /usr/libexec/gpgkeys_finger
	dosym gpg2keys_curl /usr/libexec/gpgkeys_curl
	use ldap && dosym gpg2keys_ldap /usr/libexec/gpgkeys_ldap
	echo ".so man1/gpg2.1" > "${D}usr/share/man/man1/gpg.1"
	echo ".so man1/gpgv2.1" > "${D}usr/share/man/man1/gpgv.1"

	use doc && dohtml doc/gnupg.html/* doc/*jpg doc/*png
}

pkg_postinst() {
	elog "If you wish to view images emerge:"
	elog "media-gfx/xloadimage, media-gfx/xli or any other viewer"
	elog "Remember to use photo-viewer option in configuration file to activate"
	elog "the right viewer."

	ewarn "Please remember to restart gpg-agent if a different version"
	ewarn "of the agent is currently used. If you are unsure of the gpg"
	ewarn "agent you are using please run 'killall gpg-agent',"
	ewarn "and to start a fresh daemon just run 'gpg-agent --daemon'."
}
