# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/blackdown-jdk/blackdown-jdk-1.4.2.01-r1.ebuild,v 1.2 2004/12/23 12:44:26 karltk Exp $

inherit java versionator

JREV="01"
JV=${PV%_*}
JV=$(get_version_component_range 1-3 ${JV})
J_URI="mirror://blackdown.org/JDK-${JV}"

DESCRIPTION="Blackdown Java Development Kit"
SRC_URI="amd64? ( ${J_URI}/amd64/${JREV}/j2sdk-${JV}-${JREV}-linux-amd64.bin )
	x86? ( ${J_URI}/i386/${JREV}/j2sdk-${JV}-${JREV}-linux-i586.bin )"

HOMEPAGE="http://www.blackdown.org"

SLOT="1.4.2"
LICENSE="sun-bcla-java-vm"
KEYWORDS="-* ~x86 ~amd64"
IUSE="doc mozilla"

DEPEND="virtual/libc
	>=dev-java/java-config-1.2.11
	doc? ( =dev-java/java-sdk-docs-1.4.2* )"

PROVIDE="virtual/jdk-1.4.2
	virtual/jre-1.4.2
	virtual/java-scheme-2"

S="${WORKDIR}/j2sdk${JV}"

# Extract the 'skip' value (offset of tarball) we should pass to tail
get_offset() {
	[ ! -f "$1" ] && return

	local offset=$(gawk '
		/^[[:space:]]*skip[[:space:]]*=/ {
			sub(/^[[:space:]]*skip[[:space:]]*=/, "")
			SKIP = $0
		}
		END { print SKIP }' $1)

	echo $offset
}

src_unpack() {
	local offset=$(get_offset ${DISTDIR}/${A})

	if [ -z "${offset}" ] ; then
		die "Failed to get offset of tarball!"
	fi

	echo ">>> Unpacking ${A}..."
	tail -n +${offset} ${DISTDIR}/${A} | tar --no-same-owner -jxpf - || die
}

unpack_jars() {
	# New to 1.4.2
	local PACKED_JARS="lib/tools.jar jre/lib/rt.jar jre/lib/jsse.jar jre/lib/charsets.jar jre/lib/ext/localedata.jar jre/lib/plugin.jar jre/javaws/javaws.jar"
	local JAVAHOME="${D}/opt/${P}"
	local UNPACK_CMD=""
	if [ -f "$JAVAHOME/lib/unpack" ]; then
		UNPACK_CMD="$JAVAHOME/lib/unpack"
		chmod +x "$UNPACK_CMD"
		packerror=""
		for i in $PACKED_JARS; do
			if [ -f "$JAVAHOME/`dirname $i`/`basename $i .jar`.pack" ]; then
				einfo "Creating ${JAVAHOME}/${i}\n"
				"$UNPACK_CMD" "$JAVAHOME/`dirname $i`/`basename $i .jar`.pack" "$JAVAHOME/$i"
				if [ ! -f "$JAVAHOME/$i" ]; then
					ewarn "Failed to unpack jar files ${i}. Please refer\n"
					ewarn "to the Troubleshooting section of the Installation\n"
					ewarn "Instructions on the download page for more information.n"
					packerror="1"
				fi
				rm -f "$JAVAHOME/`dirname $i`/`basename $i .jar`.pack"
			fi
		done
	fi
	rm -f "$UNPACK_CMD"
}

src_install() {
	typeset platform

	dodir /opt/${P}

	cp -a ${S}/{bin,jre,lib,man,include} ${D}/opt/${P} || die "failed to copy"

	dodir /opt/${P}/share/java
	cp -a ${S}/{demo,src.zip} ${D}/opt/${P}/share || die "failed to copy"

	dodoc COPYRIGHT LICENSE README INSTALL
	dohtml README.html

	# Install mozilla plugin if mozilla use flag is set
	if use mozilla; then
		case ${ARCH} in
			amd64) platform="amd64" ;;
			x86) platform="i386" ;;
			ppc) platform="ppc" ;;
			sparc*) platform="sparc" ;;
		esac

		install_mozilla_plugin /opt/${P}/jre/plugin/${platform}/mozilla/libjavaplugin_oji.so
	else
		rm -f ${D}/opt/${P}/jre/plugin/${platform}/mozilla/libjavaplugin_oji.so
	fi

	find ${D}/opt/${P} -type f -name "*.so" -exec chmod +x \{\} \;

	sed -i "s/standard symbols l/symbol/g" ${D}/opt/${P}/jre/lib/font.properties

	# install env into /etc/env.d
	set_java_env ${FILESDIR}/${VMHANDLE} || die

	# Fix for bug 26629
	if [ "${PROFILE_ARCH}" = "sparc64" ]
	then
		dosym /opt/${P}/jre/lib/sparc /opt/${P}/jre/lib/sparc64
	fi

	unpack_jars
}

pkg_postinst() {
	# Set as default system VM if none exists
	java_pkg_postinst

	# if chpax is on the target system, set the appropriate PaX flags
	# this will not hurt the binary, it modifies only unused ELF bits
	# but may confuse things like AV scanners and automatic tripwire
	if has_version "sys-apps/chpax"
	then
		echo
		einfo "setting up conservative PaX flags for jar and javac"

		for paxkills in "jar" "javac" "java"
		do
			chpax -${CHPAX_CONSERVATIVE_FLAGS} /opt/${PN}-${PV}/bin/$paxkills
		done

		# /opt/blackdown-jdk-1.4.1/jre/bin/java_vm
		chpax -${CHPAX_CONSERVATIVE_FLAGS} /opt/${PN}-${PV}/jre/bin/java_vm

		einfo "you should have seen lots of chpax output above now"
		ewarn "make sure the grsec ACL contains those entries also"
		ewarn "because enabling it will override the chpax setting"
		ewarn "on the physical files - help for PaX and grsecurity"
		ewarn "can be given by #gentoo-hardened + pappy@gentoo.org"
	fi
}
