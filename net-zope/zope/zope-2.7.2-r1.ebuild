# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope/zope-2.7.2-r1.ebuild,v 1.3 2004/10/02 19:20:30 radek Exp $

inherit eutils

DESCRIPTION="Zope is a web application platform used for building high-performance, dynamic web sites."
HOMEPAGE="http://www.zope.org"
SRC_URI="http://www.zope.org/Products/Zope/${PV}/Zope-${PV}-0.tgz"
LICENSE="ZPL"
SLOT="${PV}"

KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64"
IUSE="unicode"

RDEPEND="=dev-lang/python-2.3*"
python='python2.3'

DEPEND="${RDEPEND}
virtual/libc
>=sys-apps/sed-4.0.5
>=app-admin/zope-config-0.4-r1"

S="${WORKDIR}/Zope-${PV}-0"

ZUID=zope
ZGID=zope
ZGID_INST="${PN}-${PV//./_}"
ZS_DIR=${ROOT%/}/usr/lib
ZI_DIR=${ROOT%/}/var/lib/zope
ZSERVDIR=${ZS_DIR}/${PN}-${PV}
ZINSTDIR=${ZI_DIR}/${PN}-${PV}

RCNAME=zope.initd

# Narrow the scope of ownership/permissions.
# Security plan:
# * ZUID is the superuser for all zope instances.
# * ZGID is for a single instance's administration.
# * Other's should not have any access to ${ZSERVDIR},
#   because they can work through the Zope web interface.
#   This should protect our code/data better.

# Parameters:
#  $1 = instance directory
#  $2 = group
setup_security() {
	# The old version made everything owned by zope:${DEFAULT_INSTANCE_GID},
	# and group-writable. This is like making everything in net-www/apache2 
	# owned by apache! The zope instance runs as the zope user, so the zope
	# user should not own any files. However, we make everything group-owned
	# by the zope group, of which the zope user is a member, so that running
	# zope instances will be able to read everything.
	# -- Andy Dustman

	chown -R root:${2} ${1}
	chmod -R g+r,g-w,o-rwx ${1}
}

install_instance() {
	# Here we add our default zope instance.
	if [ -d ${ZINSTDIR} ] ; then
		die "Default instance directory (${ZINSTDIR}) already exists!"
	fi
	if [ -f ${ZI_DIR}/.default ] ; then
		def_instance=`cat ${ZI_DIR}/.default`
		die "Default instance file (${ZI_DIR}/.default) already exists -> $def_instance"
	fi
	einfo "Creating default zope instance at ${ZINSTDIR} with command:"
	einfo "/usr/sbin/zope-config --zserv=${ZSERVDIR} --zinst=${ZINSTDIR} --zgid=${ZGID_INST} --zinituser"
	ewarn "Default admin user created with password admin. Please change it."
	/usr/sbin/zope-config --zserv=${ZSERVDIR} --zinst=${ZINSTDIR} --zgid=${ZGID_INST} --zinituser
	einfo "You can also enable autostart on reboot using: rc-update -a ${ZGID_INST} default"
}

pkg_preinst() {
	enewgroup ${ZGID} 261
	usermod -g ${ZGID} ${ZUID} 2>&1 >/dev/null || \
	enewuser ${ZUID} 261 /bin/bash ${ZS_DIR} ${ZGID}

	#[cs] Moved setup_security here to fix Bug #59217
	setup_security ${D}${ZSERVDIR} ${ZGID}
}

src_unpack() {
	unpack ${A}
	cd ${S}
	use amd64 \
		&& epatch ${FILESDIR}/2.7.2/gid.patch
}

src_compile() {
	#[cs] TODO: ZOPE_DIR should be something else....
	./configure --ignore-largefile --prefix=${ZOPE_DIR} || die "Failed to configure."
	emake || die "Failed to compile."
}

src_install() {
	dodoc README.txt
	dodoc doc/*.txt
	docinto PLATFORMS ; dodoc doc/PLATFORMS/*

	# Patched StructuredText will accept source text formatted in utf-8 encoding, 
	# apply all formattings and output utf-8 encoded text.
	# if you want to use this option you need to set your
	# system python encoding to utf-8 (create the file sitecustomize.py inside
	# your site-packages, add the following lines
	# 	import sys
	# 	sys.setdefaultencoding('utf-8')
	# If this is a problem, let me know right away. --batlogg@gentoo.org
	# I wondering if we need a USE flag for this and wheter we can set the
	# sys.encoding automtically
	# so i defined a use flag

	if use unicode; then
		einfo "Patching structured text"
		einfo "make sure you have set the system python encoding to utf-8"
		einfo "create the file sitecustomize.py inside your site-packages"
	 	einfo "import sys"
		einfo "sys.setdefaultencoding('utf8')"
		cd ${S}/lib/python/StructuredText/
		epatch ${FILESDIR}/i18n-1.0.0.patch
		cd ${S}
	fi

	make install PREFIX=${D}${ZSERVDIR}
	rm -rf ${D}${ZSERVDIR}/doc
	dosym ${DOCDESTTREE} ${D}${ZSERVDIR}/doc

	skel=${D}${ZSERVDIR}/skel
	dodir /etc/init.d
	cp ${FILESDIR}/${PV}/zope.initd ${skel}/zope.initd
}

pkg_postinst() {
	einfo "Be warned that you need at least one zope instance to run zope."
	einfo "To create empty new default instance, please use command:"
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "Please use zope-config command for futher instance management."
}

pkg_postrm() {
	# rcscripts files will remain. i.e. /etc protection.

	# Delete .default if this ebuild is the default. zprod-manager will
	# have to handle a missing default;
	# TODO: this should be checked
	rm -f ${ZI_DIR}/.default

	# TODO: Verify this is right.
	#if [ -e ${ZI_DIR}.default ]; then
	#        if [ "$(cat ${ZI_DIR}.default)" = "${PN}-${PV}" ]; then
	#        	rm -f ${ZI_DIR}.default
	#        fi
	#fi
}

pkg_config() {
	install_instance
}

