# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-base-policy/selinux-base-policy-20080525-r1.ebuild,v 1.1 2009/09/14 19:28:57 pebenito Exp $

IUSE=""

inherit eutils

DESCRIPTION="Gentoo base policy for SELinux"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/selinux/"
SRC_URI="http://oss.tresys.com/files/refpolicy/refpolicy-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-apps/policycoreutils-1.30.30"
DEPEND="${RDEPEND}
	sys-devel/m4
	>=sys-apps/checkpolicy-1.30.12"

S=${WORKDIR}/

src_unpack() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="strict targeted"
	MOD_CONF_VER="20080525"

	unpack ${A}

#	cd "${S}/refpolicy"
#	epatch ${FILESDIR}/${PN}-${PV}.diff

	echo "fs_use_xattr ext4 gen_context(system_u:object_r:fs_t,s0);" \
		>> "${S}/refpolicy/policy/modules/kernel/filesystem.te"

	for i in ${POLICY_TYPES}; do
		cp -a "${S}/refpolicy" "${S}/${i}"

		cp "${FILESDIR}/modules.conf.${i}.${MOD_CONF_VER}" \
			"${S}/${i}/policy/modules.conf" \
			|| die "failed to set up modules.conf"
		sed -i -e '/^QUIET/s/n/y/' -e '/^MONOLITHIC/s/y/n/' \
			-e "/^NAME/s/refpolicy/$i/" "${S}/${i}/build.conf" \
			|| die "build.conf setup failed."

		echo "DISTRO = gentoo" >> "${S}/${i}/build.conf"

		if [ "${i}" == "targeted" ]; then
			sed -i -e '/root/d' -e 's/user_u/unconfined_u/' \
			"${S}/${i}/config/appconfig-standard/seusers" \
			|| die "targeted seusers setup failed."

			# add compat
			sed -i -e '/user_u/s/user_r/user_r system_r/' "${S}/${i}/policy/users" \
				|| die "targeted user compat failed."
		fi
	done
}

src_compile() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="strict targeted"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}"

		make base || die "${i} compile failed"
	done
}

src_install() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="strict targeted"

	for i in ${POLICY_TYPES}; do
		cd "${S}/${i}"

		make DESTDIR="${D}" install \
			|| die "${i} install failed."

		make DESTDIR="${D}" install-headers \
			|| die "${i} headers install failed."

		echo "run_init_t" > "${D}/etc/selinux/${i}/contexts/run_init_type"

		echo "textrel_shlib_t" >> "${D}/etc/selinux/${i}/contexts/customizable_types"

		# libsemanage won't make this on its own
		keepdir "/etc/selinux/${i}/policy"
	done

	dodoc doc/Makefile.example doc/example.{te,fc,if}

	insinto /etc/selinux
	doins "${FILESDIR}/config"
}

pkg_postinst() {
	[ -z "${POLICY_TYPES}" ] && local POLICY_TYPES="strict targeted"

	if has "loadpolicy" $FEATURES ; then
		for i in ${POLICY_TYPES}; do
			einfo "Inserting base module into ${i} module store."

			cd "/usr/share/selinux/${i}"
			semodule -s "${i}" -b base.pp
		done
	else
		echo
		echo
		eerror "Policy has not been loaded.  It is strongly suggested"
		eerror "that the policy be loaded before continuing!!"
		echo
		einfo "Automatic policy loading can be enabled by adding"
		einfo "\"loadpolicy\" to the FEATURES in make.conf."
		echo
		echo
		ebeep 4
		epause 4
	fi
}
