# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pam/pam-0.99.6.3-r1.ebuild,v 1.8 2006/10/29 16:19:57 flameeyes Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit libtool multilib eutils autotools pam toolchain-funcs

MY_P="Linux-PAM-${PV}"

HOMEPAGE="http://www.kernel.org/pub/linux/libs/pam/"
DESCRIPTION="Linux-PAM (Pluggable Authentication Modules)"

SRC_URI="http://www.kernel.org/pub/linux/libs/pam/pre/library/${MY_P}.tar.bz2"

LICENSE="PAM"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls elibc_FreeBSD selinux"

RDEPEND="nls? ( virtual/libintl )
	>=sys-libs/cracklib-2.8.3
	sys-libs/pwdb
	selinux? ( >=sys-libs/libselinux-1.28 )"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	~app-text/docbook-xml-dtd-4.3
	~app-text/docbook-xml-dtd-4.4
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

RESTRICT="confcache"

PROVIDE="virtual/pam"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir -p doc/txts
	for readme in modules/pam_*/README; do
		cp -f "${readme}" doc/txts/README.$(dirname "${readme}" | \
			sed -e 's|^modules/||')
	done

	epatch "${FILESDIR}/${MY_P}-berkdb.patch"
	epatch "${FILESDIR}/${MY_P}-linking.patch"

	AT_M4DIR="m4" eautoreconf

	elibtoolize
}

src_compile() {
	local myconf

	# don't build documentation as it doesn't seem to really work
	export SGML2PS=no
	export SGML2TXT=no
	export SGML2HTML=no
	export SGML2LATEX=no
	export PS2PDF=no

	if use hppa || use elibc_FreeBSD; then
		myconf="${myconf} --disable-pie"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable selinux) \
		--disable-berkdb \
		--enable-securedir=/$(get_libdir)/security \
		--enable-isadir=/$(get_libdir)/security \
		--disable-dependency-tracking \
		--disable-prelude \
		--enable-docdir=/usr/share/doc/${PF} \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	# Need to be suid
	fperms u+s /sbin/unix_chkpwd

	dodir /$(get_libdir)
	mv "${D}/usr/$(get_libdir)/libpam.so"* "${D}/$(get_libdir)/"
	mv "${D}/usr/$(get_libdir)/libpamc.so"* "${D}/$(get_libdir)/"
	mv "${D}/usr/$(get_libdir)/libpam_misc.so"* "${D}/$(get_libdir)/"
	gen_usr_ldscript libpam.so libpamc.so libpam_misc.so

	# No, we don't really need .la files for PAM modules.
	rm -f "${D}/$(get_libdir)/security/"*.la

	dodoc CHANGELOG ChangeLog README AUTHORS Copyright
	docinto modules ; dodoc doc/txts/README.*

	for x in "${FILESDIR}/pam.d-0.99/"*; do
		[[ -f "${x}" ]] && dopamd "${x}"
	done

	# Remove the wrongly isntalled manpage
	rm -f "${D}"/usr/share/man/man8/pam_userdb.8*
}

pkg_postinst() {
	elog "Since version 0.99 we don't apply RedHat patches anymore, thus stuff"
	elog "like pam_stack is not present (replaced by the 'include' directive)."
	elog "The pam_userdb module is now moved in sys-auth/pam_userdb."
	elog "The pam_console module is now moved in sys-auth/pam_console."
}
