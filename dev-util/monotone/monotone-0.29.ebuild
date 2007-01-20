# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monotone/monotone-0.29.ebuild,v 1.7 2007/01/20 06:27:42 dragonheart Exp $

inherit elisp-common flag-o-matic bash-completion eutils

DESCRIPTION="Monotone Distributed Version Control System"
HOMEPAGE="http://www.venge.net/monotone/"
SRC_URI="http://www.venge.net/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~ia64 ppc x86"

IUSE="doc emacs ipv6 nls"

RDEPEND="=dev-libs/boost-1.33*
	sys-libs/zlib
	emacs? ( virtual/emacs )"

DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5 )
	doc? ( sys-apps/texinfo )"


pkg_setup() {
	enewgroup monotone
	enewuser monotone -1 -1 /var/lib/monotone monotone
	if [[ "$(gcc-version)" == "3.3" ]]; then
		die 'requires >=gcc-3.4'
	fi
}

src_compile() {
	local myconf="$(use_enable nls) \
		$(use_enable ipv6)"

	# more aggressive optimizations cause trouble with the crypto library
	strip-flags
	append-flags $(test-flags -fno-stack-protector-all -fno-stack-protector)
	append-flags -fno-strict-aliasing -fno-omit-frame-pointer

	econf ${myconf} || die "configure failed"
	emake || die "Compilation failed"

	if use doc; then
		make html || die 'html compilation failed'
	fi

	use emacs && elisp-compile contrib/*.el
}

src_test() {
	make check || die "self test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	mv "${D}"/usr/share/doc/"${PN}" "${D}"/usr/share/doc/"${PF}"

	dobashcompletion contrib/monotone.bash_completion

	if use doc; then
		dohtml -r html/*
		dohtml -r figures
	fi

	if use emacs; then
		elisp-install ${PN} contrib/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/30monotone-gentoo.el
	fi

	dodoc ABOUT-NLS AUTHORS ChangeLog NEWS README* UPGRADE
	docinto contrib
	dodoc contrib/*
	newconfd "${FILESDIR}"/monotone.confd monotone
	newinitd "${FILESDIR}"/monotone.initd monotone

	insinto /etc/monotone ;
	newins "${FILESDIR}"/hooks.lua hooks.lua
	newins "${FILESDIR}"/read-permissions read-permissions
	newins "${FILESDIR}"/write-permissions write-permissions

	keepdir /var/lib/monotone/keys/ /var/log/monotone /var/run/monotone
	fowners monotone:monotone /var/lib/monotone /var/lib/monotone/keys/ \
		/var/log/monotone /var/run/monotone
}

pkg_postinst() {
	use emacs && elisp-site-regen
	bash-completion_pkg_postinst

	einfo
	einfo "For details and instructions to upgrade from previous versions,"
	einfo "please read /usr/share/doc/${PF}/UPGRADE.gz"
	einfo
	einfo "  1. edit /etc/conf.d/monotone"
	einfo "  2. import the first keys to enable access with"
	einfo "     env HOME=${homedir} mtn pubkey me@example.net | /etc/init.d/monotone import"
	einfo "     Thereafter, those with write permission can add other keys via"
	einfo "     netsync with 'monotone push --key-to-push=IDENT' and then IDENT"
	einfo "     can be used in the read-permission and write-permission files."
	einfo "  3. adjust permisions in /etc/monotone/read-permissions"
	einfo "                      and /etc/monotone/write-permissions"
	einfo "  4. start the daemon: /etc/init.d/monotone start"
	einfo "  5. make persistent: rc-update add monotone default"
	einfo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
