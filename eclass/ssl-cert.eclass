# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/ssl-cert.eclass,v 1.10 2007/12/07 22:41:04 ulm Exp $
#
# Author: Max Kalika <max@gentoo.org>
#
# This eclass implements standard installation procedure for installing
# self-signed SSL certificates.

# Conditionally depend on OpenSSL: allows inheretence
# without pulling extra packages if not needed
DEPEND="ssl? ( dev-libs/openssl )"
IUSE="ssl"

# Initializes variables and generates the needed
# OpenSSL configuration file and a CA serial file
#
# Access: private
gen_cnf() {
	# Location of the config file
	SSL_CONF="${T}/${$}ssl.cnf"
	# Location of the CA serial file
	SSL_SERIAL="${T}/${$}ca.ser"
	# Location of some random files OpenSSL can use: don't use
	# /dev/u?random here -- doesn't work properly on all platforms
	SSL_RANDOM="${T}/environment:${T}/eclass-debug.log:/etc/resolv.conf"

	# These can be overridden in the ebuild
	SSL_DAYS="${SSL_BITS:-730}"
	SSL_BITS="${SSL_BITS:-1024}"
	SSL_COUNTRY="${SSL_COUNTRY:-US}"
	SSL_STATE="${SSL_STATE:-California}"
	SSL_LOCALITY="${SSL_LOCALITY:-Santa Barbara}"
	SSL_ORGANIZATION="${SSL_ORGANIZATION:-SSL Server}"
	SSL_UNIT="${SSL_UNIT:-For Testing Purposes Only}"
	SSL_COMMONNAME="${SSL_COMMONNAME:-localhost}"
	SSL_EMAIL="${SSL_EMAIL:-root@localhost}"

	# Create the CA serial file
	echo "01" > "${SSL_SERIAL}"

	# Create the config file
	ebegin "Generating OpenSSL configuration"
	cat <<-EOF > "${SSL_CONF}"
		[ req ]
		prompt             = no
		default_bits       = ${SSL_BITS}
		distinguished_name = req_dn
		[ req_dn ]
		C                  = ${SSL_COUNTRY}
		ST                 = ${SSL_STATE}
		L                  = ${SSL_LOCALITY}
		O                  = ${SSL_ORGANIZATION}
		OU                 = ${SSL_UNIT}
		CN                 = ${SSL_COMMONNAME}
		emailAddress       = ${SSL_EMAIL}
	EOF
	eend $?

	return $?
}

# Simple function to determine whether we're creating
# a CA (which should only be done once) or final part
#
# Access: private
get_base() {
	if [ "${1}" ] ; then
		echo "${T}/${$}ca"
	else
		echo "${T}/${$}server"
	fi
}

# Generates an RSA key
#
# Access: private
gen_key() {
	local base=`get_base $1`
	ebegin "Generating ${SSL_BITS} bit RSA key${1:+ for CA}"
	/usr/bin/openssl genrsa -rand "${SSL_RANDOM}" \
		-out "${base}.key" "${SSL_BITS}" &> /dev/null
	eend $?

	return $?
}

# Generates a certificate signing request using
# the key made by gen_key()
#
# Access: private
gen_csr() {
	local base=`get_base $1`
	ebegin "Generating Certificate Signing Request${1:+ for CA}"
	/usr/bin/openssl req -config "${SSL_CONF}" -new \
		-key "${base}.key" -out "${base}.csr" &>/dev/null
	eend $?

	return $?
}

# Generates either a self-signed CA certificate using
# the csr and key made by gen_csr() and gen_key() or
# a signed server certificate using the CA cert previously
# created by gen_crt()
#
# Access: private
gen_crt() {
	local base=`get_base $1`
	if [ "${1}" ] ; then
		ebegin "Generating self-signed X.509 Certificate for CA"
		/usr/bin/openssl x509 -extfile "${SSL_CONF}" \
			-days ${SSL_DAYS} -req -signkey "${base}.key" \
			-in "${base}.csr" -out "${base}.crt" &>/dev/null
	else
		local ca=`get_base 1`
		ebegin "Generating authority-signed X.509 Certificate"
		/usr/bin/openssl x509 -extfile "${SSL_CONF}" \
			-days ${SSL_DAYS} -req -CAserial "${SSL_SERIAL}" \
			-CAkey "${ca}.key" -CA "${ca}.crt" \
			-in "${base}.csr" -out "${base}.crt" &>/dev/null
	fi
	eend $?

	return $?
}

# Generates a PEM file by concatinating the key
# and cert file created by gen_key() and gen_cert()
#
# Access: private
gen_pem() {
	local base=`get_base $1`
	ebegin "Generating PEM Certificate"
	(cat "${base}.key"; echo; cat "${base}.crt") > "${base}.pem"
	eend $?

	return $?
}

# Uses all the private functions above to generate
# and install the requested certificates
# Note: This function is deprecated, use install_cert instead
#
# Access: public
docert() {
	if [ $# -lt 1 ] ; then
		eerror "At least one argument needed"
		return 1;
	fi

	# Initialize configuration
	gen_cnf || return 1
	echo

	# Generate a CA environment
	gen_key 1 || return 1
	gen_csr 1 || return 1
	gen_crt 1 || return 1
	echo

	local count=0
	for cert in "$@" ; do
		# Sanitize and check the requested certificate
		cert="`/usr/bin/basename "${cert}"`"
		if [ -z "${cert}" ] ; then
			ewarn "Invalid certification requested, skipping"
			continue
		fi

		# Check for previous existence of generated files
		for type in key crt pem ; do
			if [ -e "${D}${INSDESTTREE}/${cert}.${type}" ] ; then
				ewarn "${D}${INSDESTTREE}/${cert}.${type}: exists, skipping"
				continue 2
			fi
		done

		# Generate the requested files
		gen_key || continue
		gen_csr || continue
		gen_crt || continue
		gen_pem || continue
		echo

		# Install the generated files and set sane permissions
		local base=`get_base`
		newins "${base}.key" "${cert}.key"
		fperms 0400 "${INSDESTTREE}/${cert}.key"
		newins "${base}.csr" "${cert}.csr"
		fperms 0444 "${INSDESTTREE}/${cert}.csr"
		newins "${base}.crt" "${cert}.crt"
		fperms 0444 "${INSDESTTREE}/${cert}.crt"
		newins "${base}.pem" "${cert}.pem"
		fperms 0400 "${INSDESTTREE}/${cert}.pem"
		count=$((${count}+1))
	done

	# Resulting status
	if [ ! ${count} ] ; then
		eerror "No certificates were generated"
		return 1
	elif [ ${count} != ${#} ] ; then
		ewarn "Some requested certificates were not generated"
	fi
}

# Uses all the private functions above to generate
# and install the requested certificates
#
# Access: public
install_cert() {
	if [ $# -lt 1 ] ; then
		eerror "At least one argument needed"
		return 1;
	fi

	case ${EBUILD_PHASE} in
		unpack|compile|test|install)
			eerror "install_cert cannot be called in ${EBUILD_PHASE}"
			return 1 ;;
	esac

	# Initialize configuration
	gen_cnf || return 1
	echo

	# Generate a CA environment
	gen_key 1 || return 1
	gen_csr 1 || return 1
	gen_crt 1 || return 1
	echo

	local count=0
	for cert in "$@" ; do
		# Check the requested certificate
		if [ -z "${cert##*/}" ] ; then
			ewarn "Invalid certification requested, skipping"
			continue
		fi

		# Check for previous existence of generated files
		for type in key csr crt pem ; do
			if [ -e "${ROOT}${cert}.${type}" ] ; then
				ewarn "${ROOT}${cert}.${type}: exists, skipping"
				continue 2
			fi
		done

		# Generate the requested files
		gen_key || continue
		gen_csr || continue
		gen_crt || continue
		gen_pem || continue
		echo

		# Install the generated files and set sane permissions
		local base=$(get_base)
		install -d "${ROOT}${cert%/*}"
		install -m0400 "${base}.key" "${ROOT}${cert}.key"
		install -m0444 "${base}.csr" "${ROOT}${cert}.csr"
		install -m0444 "${base}.crt" "${ROOT}${cert}.crt"
		install -m0400 "${base}.pem" "${ROOT}${cert}.pem"
		count=$((${count}+1))
	done

	# Resulting status
	if [ ! ${count} ] ; then
		eerror "No certificates were generated"
		return 1
	elif [ ${count} != ${#} ] ; then
		ewarn "Some requested certificates were not generated"
	fi
}
