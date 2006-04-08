# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/shadow/shadow-4.0.7-r4.ebuild,v 1.7 2006/04/08 00:58:48 vapier Exp $

inherit eutils libtool toolchain-funcs flag-o-matic multilib

# We should remove this login after pam-0.78 goes stable.
FORCE_SYSTEMAUTH_UPDATE="no"

DESCRIPTION="Utilities to deal with user accounts"
HOMEPAGE="http://shadow.pld.org.pl/"
SRC_URI="ftp://ftp.pld.org.pl/software/shadow/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="pam selinux nls skey nousuid"

RDEPEND=">=sys-libs/cracklib-2.7-r3
	pam? ( virtual/pam )
	!pam? ( !sys-apps/pam-login )
	skey? ( app-admin/skey )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.0.51-r2
	nls? ( sys-devel/gettext )"
# We moved /etc/pam.d/login to pam-login
PDEPEND="pam? ( >=sys-apps/pam-login-3.17 )"

pkg_preinst() {
	rm -f ${ROOT}/etc/pam.d/system-auth.new
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# uclibc support, corrects NIS usage
	epatch "${FILESDIR}"/shadow-4.0.4.1-nonis.patch

	# If su should not simulate a login shell, use '/bin/sh' as shell to enable
	# running of commands as user with /bin/false as shell, closing bug #15015.
	# *** This one could be a security hole; disable for now ***
	#epatch "${FILESDIR}"/${P}-nologin-run-sh.patch

	# don't install manpages if USE=-nls
	epatch "${FILESDIR}"/shadow-4.0.5-nls-manpages.patch

	# tweak the default login.defs
	epatch "${FILESDIR}"/shadow-4.0.5-login.defs.patch

	# skeychallenge call needs updating #69741
	epatch "${FILESDIR}"/shadow-4.0.5-skey.patch

	# The new configure changes do not detect utmp/logdir properly
	epatch "${FILESDIR}"/shadow-4.0.6-fix-configure.patch

	# Tweak manpages #70880
	epatch "${FILESDIR}"/shadow-4.0.6-manpages.patch

	# Fix SU_WHEEL_ONLY behavior #80345
	epatch "${FILESDIR}"/${P}-iswheel.patch

	# Fix lastlog not logged for tty's
	epatch "${FILESDIR}"/${P}-lastlog.patch

	# Make user/group names more flexible #3485 / #22920
	epatch "${FILESDIR}"/shadow-4.0.6-dots-in-usernames.patch
	epatch "${FILESDIR}"/shadow-4.0.6-long-groupnames.patch

	# Newer glibc's have a different nscd socket location #74395
	epatch "${FILESDIR}"/${P}-nscd-socket-path.patch

	# Fix EPIPE failure when writing to nscd, bug #80413
	epatch "${FILESDIR}"/${P}-nscd-EPIPE-failure.patch

	# lock down setuid perms #47208
	epatch "${FILESDIR}"/${PN}-4.0.7-perms.patch

	elibtoolize
	epunt_cxx
}

src_compile() {
	append-ldflags -Wl,-z,now
	tc-is-cross-compiler && export ac_cv_func_setpgrp_void=yes
	econf \
		--disable-desrpc \
		--with-libcrypt \
		--with-libcrack \
		--enable-shared=no \
		--enable-static=yes \
		$(use_with pam libpam) \
		$(use_with skey libskey) \
		$(use_with selinux) \
		$(use_enable nls) \
		|| die "bad configure"
	emake || die "compile problem"
}

src_install() {
	local perms=4711
	use nousuid && perms=711
	make DESTDIR="${D}" suidubinperms=${perms} install || die "install problem"
	dosym useradd /usr/sbin/adduser

	fperms go-r /bin/su /usr/bin/ch{fn,sh,age} \
		/usr/bin/{expiry,newgrp,passwd,gpasswd} || die "fperms"

	# Remove libshadow and libmisc; see bug 37725 and the following
	# comment from shadow's README.linux:
	#   Currently, libshadow.a is for internal use only, so if you see
	#   -lshadow in a Makefile of some other package, it is safe to
	#   remove it.
	rm -f "${D}"/{,usr/}$(get_libdir)/lib{misc,shadow}.{a,la}

	if use pam; then
		# These is now shipped with pam-login, and login
		# had/have a serious root exploit with pam support
		# enabled.
		for x in "${D}"/bin/login \
		         "${D}"/usr/bin/faillog "${D}"/usr/bin/lastlog \
		         "${D}"/usr/share/man/man5/faillog.5* \
		         "${D}"/usr/share/man/man8/lastlog.8* \
		         "${D}"/usr/share/man/man8/faillog.8*; do
				 [[ -f ${x} ]] && rm -f ${x}
		done
	fi

	insinto /etc
	# Using a securetty with devfs device names added
	# (compat names kept for non-devfs compatibility)
	insopts -m0600 ; doins "${FILESDIR}"/securetty
	insopts -m0600 ; doins etc/login.access
	insopts -m0644 ; doins etc/limits
	# Output arch-specific cruft
	case $(tc-arch) in
		ppc*)  echo "hvc0" >> "${D}"/etc/securetty
		       echo "hvsi0" >> "${D}"/etc/securetty;;
		hppa)  echo "ttyB0" >> "${D}"/etc/securetty;;
		arm)   echo "ttyFB0" >> "${D}"/etc/securetty;;
	esac

	# needed for 'adduser -D'
	insinto /etc/default
	insopts -m0600
	doins "${FILESDIR}"/default/useradd

	# move passwd to / to help recover broke systems #64441
	mv "${D}"/usr/bin/passwd "${D}"/bin/
	dosym /bin/passwd /usr/bin/passwd

	if use pam ; then
		local INSTALL_SYSTEM_PAMD="yes"

		# Do not install below pam.d files if we have pam-0.78 or later
		has_version '>=sys-libs/pam-0.78' && \
			INSTALL_SYSTEM_PAMD="no"

		for x in "${FILESDIR}"/pam.d-include/*; do
			case "${x##*/}" in
				"login")
					# We do no longer install this one, as its from
					# pam-login now.
					;;
				"system-auth"|"system-auth-1.1"|"other")
					# These we only install if we do not have pam-0.78
					# or later.
					[ "${INSTALL_SYSTEM_PAMD}" = "yes" ] && [ -f ${x} ] && \
						dopamd ${x}
					;;
				"su")
					# Disable support for pam_env and pam_wheel on openpam
					has_version sys-libs/pam && dopamd ${x}
					;;
				"su-openpam")
					has_version sys-libs/openpam && newpamd ${x} su
					;;
				*)
					[ -f ${x} ] && dopamd ${x}
					;;
			esac
		done
		for x in chage chsh chfn chpasswd newusers \
		         user{add,del,mod} group{add,del,mod} ; do
			newpamd "${FILESDIR}"/pam.d-include/shadow ${x}
		done

		# Only add this one if needed.
		if [ "${FORCE_SYSTEMAUTH_UPDATE}" = "yes" ]; then
			newpamd "${FILESDIR}"/pam.d-include/system-auth-1.1 system-auth.new || \
				die "Failed to install system-auth.new!"
		fi

		# remove manpages that pam will install for us
		# and/or don't apply when using pam

		find "${D}"/usr/share/man \
			'(' -name 'login.1' -o -name 'suauth.5' ')' \
			-exec rm {} \;
	else
		insinto /etc
		insopts -m0644
		newins etc/login.defs.linux login.defs
	fi

	# Remove manpages that are handled by other packages
	find "${D}"/usr/share/man \
		'(' -name id.1 -o -name passwd.5 -o -name getspnam.3 ')' \
		-exec rm {} \;

	cd "${S}"/doc
	dodoc INSTALL README WISHLIST
	docinto txt
	dodoc HOWTO LSM README.* *.txt
}

pkg_postinst() {
	use pam || return 0;

	if [ "${FORCE_SYSTEMAUTH_UPDATE}" = "yes" ]; then
		local CHECK1="$(md5sum ${ROOT}/etc/pam.d/system-auth | cut -d ' ' -f 1)"
		local CHECK2="$(md5sum ${ROOT}/etc/pam.d/system-auth.new | cut -d ' ' -f 1)"

		if [ "${CHECK1}" != "${CHECK2}" ]; then
			ewarn "Due to a security issue, ${ROOT}etc/pam.d/system-auth "
			ewarn "is being updated automatically. Your old "
			ewarn "system-auth will be backed up as:"
			ewarn
			ewarn "  ${ROOT}etc/pam.d/system-auth.bak"
			echo

			cp -pPR ${ROOT}/etc/pam.d/system-auth \
				${ROOT}/etc/pam.d/system-auth.bak;
			mv -f ${ROOT}/etc/pam.d/system-auth.new \
				${ROOT}/etc/pam.d/system-auth
			rm -f ${ROOT}/etc/pam.d/._cfg????_system-auth
		else
			rm -f ${ROOT}/etc/pam.d/system-auth.new
		fi
	fi
}
