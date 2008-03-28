# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/openrc/openrc-0.2-r1.ebuild,v 1.8 2008/03/28 18:56:57 vapier Exp $

inherit eutils flag-o-matic multilib toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/openrc.git"
	EGIT_BRANCH="Gentoo"
	inherit git
else
	SRC_URI="http://roy.marples.name/${PN}/${P}.tar.bz2
		mirror://gentoo/${P}.tar.bz2
		http://dev.gentoo.org/~cardoe/files/${P}.tar.bz2
		http://dev.gentoo.org/~vapier/dist/${P}.tar.bz2"
fi

DESCRIPTION="OpenRC manages the services, startup and shutdown of a host"
HOMEPAGE="http://roy.marples.name/openrc"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc-fbsd ~x86 ~x86-fbsd" #"~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="debug ncurses pam unicode kernel_linux kernel_FreeBSD"

RDEPEND="virtual/init
	kernel_linux? ( >=sys-apps/module-init-tools-3.2.2-r2 )
	kernel_FreeBSD? ( sys-process/fuser-bsd )
	ncurses? ( sys-libs/ncurses )
	pam? ( virtual/pam )
	>=sys-apps/baselayout-2.0.0
	!<sys-fs/udev-118-r2"
DEPEND="${RDEPEND}
	virtual/os-headers"

pkg_setup() {
	LIBDIR="lib"
	[ "${SYMLINK_LIB}" = "yes" ] && LIBDIR=$(get_abi_LIBDIR "${DEFAULT_ABI}")

	MAKE_ARGS="${MAKE_ARGS} LIBNAME=${LIBDIR}"

	local brand="Unknown"
	if use kernel_linux ; then
		MAKE_ARGS="${MAKE_ARGS} OS=Linux"
		brand="Linux"
	elif use kernel_FreeBSD ; then
		MAKE_ARGS="${MAKE_ARGS} OS=FreeBSD"
		brand="FreeBSD"
	fi
	export BRANDING="Gentoo ${brand}"

	export DEBUG=$(usev debug)
	export MKPAM=$(usev pam)
	export MKTERMCAP=$(usev ncurses)
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-0.2-freebsd-install-rc.patch
}

src_compile() {
	# catch people running `ebuild` w/out setup
	if [[ -z ${MAKE_ARGS} ]] ; then
		die "Your MAKE_ARGS is empty ... are you running 'ebuild' but forgot to execute 'setup' ?"
	fi

	if [[ ${PV} == "9999" ]] ; then
		local ver="git-$(git --git-dir=${EGIT_STORE_DIR}/${EGIT_PROJECT} rev-parse --verify ${EGIT_BRANCH} | cut -c1-8)"
		sed -i "/^VERSION[[:space:]]*=/s:=.*:=${ver}:" Makefile
	fi

	tc-export CC AR RANLIB
	echo emake ${MAKE_ARGS}
	emake ${MAKE_ARGS} || die "emake ${MAKE_ARGS} failed"
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install || die "make install failed"
	gen_usr_ldscript libeinfo.so
	gen_usr_ldscript librc.so

	keepdir /"${LIBDIR}"/rc/init.d
	keepdir /"${LIBDIR}"/rc/tmp

	# Backup our default runlevels
	dodir /usr/share/"${PN}"
	mv "${D}/etc/runlevels" "${D}/usr/share/${PN}"

	# Setup unicode defaults for silly unicode users
	use unicode && sed -i -e '/^unicode=/s:NO:YES:' "${D}"/etc/rc.conf

	# Cater to the norm
	(use x86 || use amd64) && sed -i -e '/^windowkeys=/s:NO:YES:' "${D}"/etc/conf.d/keymaps
}

pkg_preinst() {
	local f

	# default net script is just comments, so no point in biting people
	# in the ass by accident
	[[ -e ${ROOT}/etc/conf.d/net ]] && rm -f "${D}"/etc/conf.d/net

	# /etc/conf.d/clock moved to /etc/conf.d/hwclock
	local clock
	use kernel_FreeBSD && clock="adjkerntz" || clock="hwclock"
	if [[ -e ${ROOT}/etc/conf.d/clock ]] ; then
		mv "${ROOT}"/etc/conf.d/clock "${ROOT}"/etc/conf.d/${clock}
	fi
	if [[ -L ${ROOT}/etc/runlevels/boot/clock ]] ; then
		rm -f "${ROOT}"/etc/runlevels/boot/clock
		ln -snf /etc/init.d/${clock} "${ROOT}"/etc/runlevels/boot/${clock}
	fi
	if [[ -L ${ROOT}${LIBDIR}/rc/init.d/started/clock ]] ; then
		rm -f "${ROOT}${LIBDIR}"/rc/init.d/started/clock
		ln -snf /etc/init.d/${clock} "${ROOT}${LIBDIR}"/rc/init.d/started/${clock}
	fi

	# /etc/conf.d/rc is no longer used for configuration
	if [[ -e ${ROOT}/etc/conf.d/rc ]] ; then
		elog "/etc/conf.d/rc is no longer used for configuration."
		elog "Please migrate your settings and delete it."
	fi

	# upgrade timezone file
	if [[ -e ${ROOT}/etc/conf.d/clock && ! -e ${ROOT}/etc/timezone ]] ; then
		(
		source "${ROOT}"/etc/conf.d/clock
		[[ -n ${TIMEZONE} ]] && echo "${TIMEZONE}" > "${ROOT}"/etc/timezone
		)
	fi

	# force net init.d scripts into symlinks
	for f in "${ROOT}"/etc/init.d/net.* ; do
		if [[ ! -L ${f} ]] ; then
			elog "Moved net service '${f##*/}' to '${f##*/}.openrc.bak' to force a symlink."
			elog "You should delete '${f##*/}.openrc.bak' if you don't need it."
			mv "${f}" "${f}.openrc.bak"
			ln -snf net.lo "${f}"
		fi
	done

	# skip remaining migration if we already have openrc installed
	has_version sys-apps/openrc && return 0

	# baselayout boot init scripts have been split out
	for f in $(cd "${D}"/usr/share/${PN}/runlevels/boot || exit; echo *) ; do
		[[ -e ${ROOT}/etc/runlevels/boot/${f} ]] && continue
		elog "Auto-adding '${f}' service to your boot runlevel"
		ln -snf /etc/init.d/${f} "${ROOT}"/etc/runlevels/boot/${f}
	done

	# Upgrade out state for baselayout-1 users
	if [[ ! -e ${ROOT}${LIBDIR}/rc/init.d/started ]] ; then
		(
		[[ -e ${ROOT}/etc/conf.d/rc ]] && source "${ROOT}"/etc/conf.d/rc
		svcdir=${svcdir:-/var/lib/init.d}
		if [[ ! -d ${ROOT}${svcdir}/started ]] ; then
			ewarn "No state found, and no state exists"
			elog "You should reboot this host"
		else
			mkdir -p "${ROOT}${LIBDIR}/rc/init.d"
			einfo "Moving state from ${ROOT}${svcdir} to ${ROOT}${LIBDIR}/rc/init.d"
			mv "${ROOT}${svcdir}"/* "${ROOT}${LIBDIR}"/rc/init.d
			rm -rf "${ROOT}${LIBDIR}"/rc/init.d/daemons \
				"${ROOT}${LIBDIR}"/rc/init.d/console
			umount "${ROOT}${svcdir}" 2>/dev/null
			rm -rf "${ROOT}${svcdir}"
		fi
		)
	fi

	# Handle the /etc/modules.autoload.d -> /etc/conf.d/modules transition
	if [[ -d ${ROOT}/etc/modules.autoload.d ]] ; then
		elog "Converting your /etc/modules.autoload.d/ files to /etc/conf.d/modules"
		rm -f "${ROOT}"/etc/modules.autoload.d/.keep*
		rmdir "${ROOT}"/etc/modules.autoload.d 2>/dev/null
		if [[ -d ${ROOT}/etc/modules.autoload.d ]] ; then
			local f v
			for f in "${ROOT}"/etc/modules.autoload.d/* ; do
				v=${f##*/}
				v=${v#kernel-}
				v=${v//[^[:alnum:]]/_}
				gawk -v v="${v}" -v f="${f##*/}" '
				BEGIN { print "\n### START: Auto-converted from " f "\n" }
				{
					if ($0 ~ /^[^#]/) {
						print "modules_" v "=\"${modules_" v "} " $1 "\""
						gsub(/[^[:alnum:]]/, "_", $1)
						printf "module_" $1 "_args_" v "=\""
						for (i = 2; i <= NF; ++i) {
							if (i > 2)
								printf " "
							printf $i
						}
						print "\"\n"
					} else
						print
				}
				END { print "\n### END: Auto-converted from " f "\n" }
				' "${f}" >> "${D}"/etc/conf.d/modules
			done
				rm -f "${f}"
			rmdir "${ROOT}"/etc/modules.autoload.d 2>/dev/null
		fi
	fi
}

pkg_postinst() {
	# Remove old baselayout links
	rm -f "${ROOT}"/etc/runlevels/boot/{check{fs,root},rmnologin}

	# Make our runlevels if they don't exist
	if [[ ! -e ${ROOT}/etc/runlevels ]] ; then
		einfo "Copying across default runlevels"
		cp -RPp "${ROOT}"/usr/share/${PN}/runlevels "${ROOT}"/etc
	fi

	if [[ -d ${ROOT}/etc/modules.autoload.d ]] ; then
		ewarn "/etc/modules.autoload.d is no longer used.  Please convert"
		ewarn "your files to /etc/conf.d/modules and delete the directory."
	fi

	elog "You should now update all files in /etc, using etc-update"
	elog "or equivalent before restarting any services or this host."
}
