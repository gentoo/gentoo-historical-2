# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/pam/pam-0.99.8.1-r1.ebuild,v 1.14 2008/02/01 07:37:43 robbat2 Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit libtool multilib eutils autotools pam toolchain-funcs

MY_PN="Linux-PAM"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="http://www.kernel.org/pub/linux/libs/pam/"
DESCRIPTION="Linux-PAM (Pluggable Authentication Modules)"

SRC_URI="mirror://kernel/linux/libs/pam/pre/library/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-ldflags-to-libadd.patch.bz2"

LICENSE="PAM"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="cracklib nls elibc_FreeBSD selinux vim-syntax audit test elibc_glibc"

RDEPEND="nls? ( virtual/libintl )
	cracklib? ( >=sys-libs/cracklib-2.8.3 )
	audit? ( sys-process/audit )
	sys-libs/pwdb
	selinux? ( >=sys-libs/libselinux-1.28 )"
DEPEND="${RDEPEND}
	test? ( elibc_glibc? ( >=sys-libs/glibc-2.4 ) )
	nls? ( sys-devel/gettext )"
PDEPEND="vim-syntax? ( app-vim/pam-syntax )"

S="${WORKDIR}/${MY_P}"

PROVIDE="virtual/pam"

check_old_modules() {
	local retval="0"

	if sed -e 's:#.*::' /etc/pam.d/* 2>/dev/null | fgrep -q pam_stack.so; then
		eerror ""
		eerror "Your current setup is using the pam_stack module."
		eerror "This module is deprecated and no longer supported, and since version"
		eerror "0.99 is no longer installed, nor provided by any other package."
		eerror "The package will be built (to allow binary package builds), but will"
		eerror "not be installed."
		eerror "Please replace pam_stack usage with proper include directive usage,"
		eerror "following the PAM Upgrade guide at the following URL"
		eerror "  http://www.gentoo.org/proj/en/base/pam/upgrade-0.99.xml"
		eerror ""
		ebeep 15

		retval=1
	fi

	if sed -e 's:#.*::' /etc/pam.d/* 2>/dev/null | egrep -q 'pam_(pwdb|radius|timestamp)'; then
		eerror ""
		eerror "Your current setup is using one or more of the following modules,"
		eerror "that are not built or supported anymore:"
		eerror "pam_pwdb, pam_radius, pam_timestamp"
		eerror "If you are in real need for these modules, please contact the maintainers"
		eerror "of PAM through http://bugs.gentoo.org/ providing information about its"
		eerror "use cases."
		ebeep 10

		retval=1
	fi

	# Produce the warnings only during upgrade, for the following two
	has_version '<sys-libs/pam-0.99' || return $retval

	# This works only for those modules that are moved to sys-auth/$module, or the
	# message will be wrong.
	for module in pam_chroot pam_console pam_userdb; do
		if sed -e 's:#.*::' /etc/pam.d/* 2>/dev/null | fgrep -q ${module}.so; then
			ewarn ""
			ewarn "Your current setup is using the ${module} module."
			ewarn "Since version 0.99, ${CATEGORY}/${PN} does not provide this module"
			ewarn "anymore; if you want to continue using this module, you should install"
			ewarn "sys-auth/${module}."
			ewarn ""
			ebeep 5
		fi
	done

	return $retval
}

pkg_setup() {
	check_old_modules
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir -p doc/txts
	for readme in modules/pam_*/README; do
		cp -f "${readme}" doc/txts/README.$(dirname "${readme}" | \
			sed -e 's|^modules/||')
	done

	epatch "${DISTDIR}/${MY_P}-ldflags-to-libadd.patch.bz2"
	epatch "${FILESDIR}/${MY_PN}-0.99.7.0-disable-regenerate-man.patch"
	epatch "${FILESDIR}/${MY_PN}-0.99.8.1-xtests.patch"

	AT_M4DIR="m4" eautoreconf

	elibtoolize
}

src_compile() {
	local myconf

	if use hppa || use elibc_FreeBSD; then
		myconf="${myconf} --disable-pie"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable selinux) \
		$(use_enable cracklib) \
		$(use_enable audit) \
		--libdir=/usr/$(get_libdir) \
		--disable-db \
		--enable-securedir=/$(get_libdir)/security \
		--enable-isadir=/$(get_libdir)/security \
		--disable-dependency-tracking \
		--disable-prelude \
		--enable-docdir=/usr/share/doc/${PF} \
		--disable-regenerate-man \
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

	newpamd "${FILESDIR}/system-auth.pamd.epam" system-auth
	newpamd "${FILESDIR}/other.pamd" other

	# Remove the wrongly installed manpages
	rm "${D}"/usr/share/man/man8/pam_userdb.8*
	use cracklib || rm "${D}"/usr/share/man/man8/pam_cracklib.8*
}

pkg_preinst() {
	check_old_modules || die "deprecated PAM modules still used"

	pam_epam_expand "${D}"/etc/pam.d/*
}

pkg_postinst() {
	if ! use cracklib; then
		ewarn "You chosen not to enable cracklib. Make sure you run etc-update or"
		ewarn "you won't be able to change users' passwords."
	fi
}
