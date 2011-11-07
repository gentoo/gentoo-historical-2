# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev/udev-174-r1.ebuild,v 1.1 2011/11/07 04:19:01 williamh Exp $

EAPI=4

KV_min=2.6.34
patchversion=1
scriptversion=5
udev_rules_md5=f7ceae528475742f75516c532ec95a88

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/hotplug/udev.git"

[[ ${PV} == "9999" ]] && vcs="git-2 autotools"
inherit ${vcs} eutils flag-o-matic multilib toolchain-funcs linux-info systemd

scriptname=${PN}-gentoo-scripts
if [[ ${PV} != "9999" ]]
then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-linux"
	SRC_URI="http://people.freedesktop.org/~kay/${P}.tar.bz2"
	if [[ -n "${patchversion}" ]]
	then
		patchset=${P}-patchset-${patchversion}
		SRC_URI="${SRC_URI} mirror://gentoo/${patchset}.tar.bz2"
	fi
	scriptname="${scriptname}-${scriptversion}"
	SRC_URI="${SRC_URI} mirror://gentoo/${scriptname}.tar.bz2"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="build selinux debug +rule_generator hwdb acl gudev introspection
	keymap floppy edd doc"
[[ ${PV} == "9999" ]] && IUSE="${IUSE} test"

RESTRICT="test? ( userpriv )"

COMMON_DEPEND="selinux? ( sys-libs/libselinux )
	acl? ( sys-apps/acl dev-libs/glib:2 )
	gudev? ( dev-libs/glib:2 )
	introspection? ( dev-libs/gobject-introspection )
	>=sys-apps/util-linux-2.16
	>=sys-libs/glibc-2.10"

DEPEND="${COMMON_DEPEND}
	keymap? ( dev-util/gperf )
	dev-util/pkgconfig
	virtual/os-headers
	!<sys-kernel/linux-headers-2.6.34"

if [[ $PV == "9999" ]]
then
	DEPEND="${DEPEND}
		test? ( app-text/tree )"
fi

if [[ ${PV} == "9999" ]] || use doc
then
	# for documentation processing with xsltproc
	DEPEND="${DEPEND}
		dev-util/gtk-doc"
fi

RDEPEND="${COMMON_DEPEND}
	hwdb? ( >=sys-apps/usbutils-0.82 sys-apps/pciutils )
	acl? ( sys-apps/coreutils[acl] )
	!sys-apps/coldplug
	!<sys-fs/lvm2-2.02.45
	!sys-fs/device-mapper
	>=sys-apps/baselayout-1.12.5"

# required kernel options
CONFIG_CHECK="~INOTIFY_USER ~SIGNALFD ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2
	~!IDE ~BLK_DEV_BSG ~TMPFS_POSIX_ACL"

udev_check_KV()
{
	if kernel_is lt ${KV_min//./ }
	then
		return 1
	fi
	return 0
}

pkg_setup()
{
	linux-info_pkg_setup

	# always print kernel version requirements
	ewarn
	ewarn "${P} does not support Linux kernel before version ${KV_min}!"

	if ! udev_check_KV
	then
		eerror "Your kernel version (${KV_FULL}) is too old to run ${P}"
	fi

	KV_FULL_SRC=${KV_FULL}
	get_running_version
	if ! udev_check_KV
	then
		eerror
		eerror "udev cannot be restarted after emerging,"
		eerror "as your running kernel version (${KV_FULL}) is too old."
		eerror "You really need to use a newer kernel after a reboot!"
		NO_RESTART=1
	fi
}

if [[ $PV == 9999 ]]
then
	src_unpack()
	{
		git-2_src_unpack
		unset EGIT_BRANCH
		unset EGIT_COMMIT
		unset EGIT_DIR
		unset EGIT_MASTER
		EGIT_PROJECT="${scriptname}"
		EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/${scriptname}.git"
		EGIT_SOURCEDIR="${WORKDIR}/${scriptname}"
		git-2_src_unpack
	}
fi

src_prepare()
{
	# backport some patches
	if [[ -n "${patchset}" ]]
	then
		EPATCH_SOURCE="${WORKDIR}/${patchset}" EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" epatch
	fi

	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' \
		-i rules/{rules.d,arch}/*.rules \
	|| die "failed to change group dialout to uucp"

	if [[ ${PV} != 9999 ]]
	then
		# Make sure there is no sudden changes to upstream rules file
		# (more for my own needs than anything else ...)
		MD5=$(md5sum < "${S}/rules/rules.d/50-udev-default.rules")
		MD5=${MD5/  -/}
		if [[ ${MD5} != ${udev_rules_md5} ]]
		then
			eerror "50-udev-default.rules has been updated, please validate!"
			eerror "md5sum: ${MD5}"
			die "50-udev-default.rules has been updated, please validate!"
		fi
	fi

	if [[ ${PV} == 9999 ]]
	then
		gtkdocize --copy || die "gtkdocize failed"
		eautoreconf
	fi
}

src_configure()
{
	filter-flags -fprefetch-loop-arrays
	econf \
		--prefix="${EPREFIX}/usr" \
		--sysconfdir="${EPREFIX}/etc" \
		--sbindir="${EPREFIX}/sbin" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-rootlibdir="${EPREFIX}/$(get_libdir)" \
		--libexecdir="${EPREFIX}/lib/udev" \
		--enable-logging \
		--enable-static \
		$(use_with selinux) \
		$(use_enable debug) \
		$(use_enable rule_generator) \
		$(use_enable hwdb) \
		--with-pci-ids-path="${EPREFIX}/usr/share/misc/pci.ids" \
		--with-usb-ids-path="${EPREFIX}/usr/share/misc/usb.ids" \
		$(use_enable acl udev_acl) \
		$(use_enable gudev) \
		$(use_enable introspection) \
		$(use_enable keymap) \
		$(use_enable floppy) \
		$(use_enable edd) \
		$(use_enable doc gtk-doc) \
		$(systemd_with_unitdir)
}

src_install()
{
	emake DESTDIR="${D}" docdir="/usr/share/doc/${P}" install

	# documentation
	dodoc ChangeLog README TODO

	if use keymap
	then
		dodoc extras/keymap/README.keymap.txt
	fi

	# Upstream moved udevd to /lib/udev,, so symlnking it is the easiest option
	dosym "../lib/udev/udevd" /sbin/udevd

	# create symlinks for these utilities to /sbin
	# where multipath-tools expect them to be (Bug #168588)
	dosym "../lib/udev/scsi_id" /sbin/scsi_id

	# Add gentoo stuff to udev.conf
	echo "# If you need to change mount-options, do it in /etc/fstab" \
	>> "${ED}"/etc/udev/udev.conf

	# Now install rules
	insinto /lib/udev/rules.d/

	# support older kernels
	doins rules/misc/30-kernel-compat.rules

	# add arch specific rules
	if [[ -f rules/arch/40-${ARCH}.rules ]]
	then
		doins "rules/arch/40-${ARCH}.rules"
	fi

	cd "${WORKDIR}/${scriptname}"
	doconfd conf.d/*
	exeinto /lib/udev
	doexe helpers/*
	doinitd init.d/*
	insinto /etc/modprobe.d
	doins modprobe.d/*
	insinto /lib/udev/rules.d
	doins rules.d/*
}

# 19 Nov 2008
fix_old_persistent_net_rules()
{
	local rules=${EROOT}/etc/udev/rules.d/70-persistent-net.rules
	[[ -f ${rules} ]] || return

	elog
	elog "Updating persistent-net rules file"

	# Change ATTRS to ATTR matches, Bug #246927
	sed -i -e 's/ATTRS{/ATTR{/g' "${rules}"

	# Add KERNEL matches if missing, Bug #246849
	sed -ri \
		-e '/KERNEL/ ! { s/NAME="(eth|wlan|ath)([0-9]+)"/KERNEL=="\1*", NAME="\1\2"/}' \
		"${rules}"
}

# See Bug #129204 for a discussion about restarting udevd
restart_udevd()
{
	if [[ ${NO_RESTART} = "1" ]]
	then
		ewarn "Not restarting udevd, as your kernel is too old!"
		return
	fi

	# need to merge to our system
	[[ ${EROOT} = / ]] || return

	# check if root of init-process is identical to ours (not in chroot)
	[[ -r /proc/1/root && /proc/1/root/ -ef /proc/self/root/ ]] || return

	# abort if there is no udevd running
	[[ -n $(pidof udevd) ]] || return

	# abort if no /dev/.udev exists
	[[ -e /dev/.udev ]] || return

	elog
	elog "restarting udevd now."

	killall -15 udevd &>/dev/null
	sleep 1
	killall -9 udevd &>/dev/null

	/sbin/udevd --daemon
	sleep 3
	if [[ ! -n $(pidof udevd) ]]
	then
		eerror "FATAL: udev died, please check your kernel is"
		eerror "new enough and configured correctly for ${P}."
		eerror
		eerror "Please have a look at this before rebooting."
		eerror "If in doubt, please downgrade udev back to your old version"
	fi
}

postinst_init_scripts()
{
	local enable_postmount=false

	# FIXME: inconsistent handling of init-scripts here
	#  * udev is added to sysinit in openrc-ebuild
	#  * we add udev-postmount to default in here
	#

	# If we are building stages, add udev to the sysinit runlevel automatically.
	if use build
	then
		if [[ -x "${EROOT}"/etc/init.d/udev  \
			&& -d "${EROOT}"/etc/runlevels/sysinit ]]
		then
			ln -s "${EPREFIX}"/etc/init.d/udev "${EROOT}"/etc/runlevels/sysinit/udev
		fi
		enable_postmount=true
	fi

	# migration to >=openrc-0.4
	if [[ -e "${EROOT}"/etc/runlevels/sysinit && ! -e "${EROOT}"/etc/runlevels/sysinit/udev ]]
	then
		ewarn
		ewarn "You need to add the udev init script to the runlevel sysinit,"
		ewarn "else your system will not be able to boot"
		ewarn "after updating to >=openrc-0.4.0"
		ewarn "Run this to enable udev for >=openrc-0.4.0:"
		ewarn "\trc-update add udev sysinit"
		ewarn
	fi

	# add udev-postmount to default runlevel instead of that ugly injecting
	# like a hotplug event, 2009/10/15

	# already enabled?
	[[ -e "${EROOT}"/etc/runlevels/default/udev-postmount ]] && return

	[[ -e "${EROOT}"/etc/runlevels/sysinit/udev ]] && enable_postmount=true
	[[ "${EROOT}" = "/" && -d /dev/.udev/ ]] && enable_postmount=true

	if $enable_postmount
	then
		local initd=udev-postmount

		if [[ -e ${EROOT}/etc/init.d/${initd} ]] && \
			[[ ! -e ${EROOT}/etc/runlevels/default/${initd} ]]
		then
			ln -snf "${EPREFIX}"/etc/init.d/${initd} "${EROOT}"/etc/runlevels/default/${initd}
			elog "Auto-adding '${initd}' service to your default runlevel"
		fi
	else
		elog "You should add the udev-postmount service to default runlevel."
		elog "Run this to add it:"
		elog "\trc-update add udev-postmount default"
	fi
}

pkg_postinst()
{
	fix_old_persistent_net_rules

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${EROOT}"/dev/loop 2>/dev/null
	if [[ -d "${EROOT}"/dev/loop ]]
	then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	restart_udevd

	postinst_init_scripts

	# people want reminders, I'll give them reminders.  Odds are they will
	# just ignore them anyway...

	# Removing some device-nodes we thought we need some time ago, 25 Jan 2007
	if [[ -d ${EROOT}/lib/udev/devices ]]
	then
		rm -f "${EROOT}"/lib/udev/devices/{null,zero,console,urandom}
	fi

	# Try to remove /etc/dev.d as that is obsolete, 23 Apr 2007
	if [[ -d ${EROOT}/etc/dev.d ]]
	then
		rmdir --ignore-fail-on-non-empty "${EROOT}"/etc/dev.d/default "${EROOT}"/etc/dev.d 2>/dev/null
		if [[ -d ${EROOT}/etc/dev.d ]]
		then
			ewarn "You still have the directory /etc/dev.d on your system."
			ewarn "This is no longer used by udev and can be removed."
		fi
	fi

	# 64-device-mapper.rules now gets installed by sys-fs/device-mapper
	# remove it if user don't has sys-fs/device-mapper installed, 27 Jun 2007
	if [[ -f ${EROOT}/etc/udev/rules.d/64-device-mapper.rules ]] &&
		! has_version sys-fs/device-mapper
	then
			rm -f "${EROOT}"/etc/udev/rules.d/64-device-mapper.rules
			einfo "Removed unneeded file 64-device-mapper.rules"
	fi

	# requested in Bug #225033:
	elog
	elog "persistent-net assigns fixed names to network devices."
	elog "If you have problems with the persistent-net rules,"
	elog "just delete the rules file"
	elog "\trm ${EROOT}etc/udev/rules.d/70-persistent-net.rules"
	elog "then reboot."
	elog
	elog "This may however number your devices in a different way than they are now."

	ewarn
	ewarn "If you build an initramfs including udev, then please"
	ewarn "make sure that the /sbin/udevadm binary gets included,"
	ewarn "and your scripts changed to use it,as it replaces the"
	ewarn "old helper apps udevinfo, udevtrigger, ..."

	ewarn
	ewarn "mount options for directory /dev are no longer"
	ewarn "set in /etc/udev/udev.conf, but in /etc/fstab"
	ewarn "as for other directories."

	ewarn
	ewarn "If you use /dev/md/*, /dev/loop/* or /dev/rd/*,"
	ewarn "then please migrate over to using the device names"
	ewarn "/dev/md*, /dev/loop* and /dev/ram*."
	ewarn "The devfs-compat rules have been removed."
	ewarn "For reference see Bug #269359."

	ewarn
	ewarn "Rules for /dev/hd* devices have been removed"
	ewarn "Please migrate to libata."

	ewarn
	ewarn "action_modeswitch has been removed by upstream."
	ewarn "Please use sys-apps/usb_modeswitch."

	elog
	elog "For more information on udev on Gentoo, writing udev rules, and"
	elog "         fixing known issues visit:"
	elog "         http://www.gentoo.org/doc/en/udev-guide.xml"
}
