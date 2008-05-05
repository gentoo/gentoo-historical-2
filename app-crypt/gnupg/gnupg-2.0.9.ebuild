# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-2.0.9.ebuild,v 1.8 2008/05/05 19:02:32 ranger Exp $

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="bzip2 doc ldap nls openct pcsc-lite smartcard selinux"

COMMON_DEPEND="
	virtual/libc
	>=dev-libs/pth-1.3.7
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libksba-1.0.2
	>=dev-libs/libgpg-error-1.4
	>=net-misc/curl-7.7.2
	bzip2? ( app-arch/bzip2 )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )
	openct? ( >=dev-libs/openct-0.5.0 )
	ldap? ( net-nds/openldap )
	app-crypt/pinentry"

DEPEND="${COMMON_DEPEND}
	>=dev-libs/libassuan-1.0.4
	nls? ( sys-devel/gettext )
	doc? ( sys-apps/texinfo )"

RDEPEND="${COMMON_DEPEND}
	!app-crypt/gpg-agent
	!<=app-crypt/gnupg-2.0.1
	virtual/mta
	selinux? ( sec-policy/selinux-gnupg )
	nls? ( virtual/libintl )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc-4.3.patch"
}

src_compile() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-symcryptrun \
		--enable-gpg \
		--enable-gpgsm \
		--enable-agent \
		$(use_enable bzip2) \
		$(use_enable smartcard scdaemon) \
		$(use_enable nls) \
		$(use_enable ldap) \
		--disable-capabilities \
		CC_FOR_BUILD=$(tc-getBUILD_CC) \
		|| die
	emake || die
	if use doc; then
		cd doc
		emake html || die
	fi
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README THANKS TODO VERSION

	mv "${D}/usr/share/gnupg"/{help*,faq*,FAQ} "${D}/usr/share/doc/${PF}"
	prepalldocs

	dosym gpg2 /usr/bin/gpg
	dosym gpgv2 /usr/bin/gpgv
	dosym gpg2keys_hkp /usr/libexec/gpgkeys_hkp
	dosym gpg2keys_finger /usr/libexec/gpgkeys_finger
	dosym gpg2keys_curl /usr/libexec/gpgkeys_curl
	use ldap && dosym gpg2keys_ldap /usr/libexec/gpgkeys_ldap
	echo ".so man1/gpg2.1" > "${D}/usr/share/man/man1/gpg.1"
	echo ".so man1/gpgv2.1" > "${D}/usr/share/man/man1/gpgv.1"

	use doc && dohtml doc/gnupg.html/* doc/*jpg doc/*png
}

pkg_postinst() {
	elog "If you wish to view images emerge:"
	elog "media-gfx/xloadimage, media-gfx/xli or any other viewer"
	elog "Remember to use photo-viewer option in configuration file to activate"
	elog "the right viewer"
}
